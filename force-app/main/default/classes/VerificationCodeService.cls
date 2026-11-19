/*****************************************************************
Name:          VerificationCodeService
============================================================
Purpose:       Shared logic for the UC Assist identity verification
               and password reset build: settings, code and token
               generation, hashing, eligible Contact matching,
               lazy expiry of stale codes and Case logging.
               Runs WITHOUT SHARING, and the portal User and queue
               lookups run WITH SYSTEM_MODE, on purpose: the Einstein
               agent user holds no role, so it cannot see customer
               users through sharing. Each lookup is narrowed to an
               exact email or queue name, and nothing beyond a
               neutral message reaches the conversation (spec V14).
               Verification Code and Case DML stays in user mode, so
               the agent user's permission sets still apply.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 Apex
*****************************************************************/
public without sharing class VerificationCodeService {

    // Status values of Verification_Code__c.Status__c
    public static final String STATUS_SENT = 'Sent';
    public static final String STATUS_VERIFIED = 'Verified';
    public static final String STATUS_CONSUMED = 'Consumed';
    public static final String STATUS_EXPIRED = 'Expired';
    public static final String STATUS_LOCKED = 'Locked';

    // Case values used on every password reset outcome (C1/C2)
    public static final String CASE_ORIGIN = 'Chat';
    public static final String CASE_REASON = 'Password Reset';
    public static final String CASE_STATUS_NEW = 'New';
    public static final String CASE_STATUS_CLOSED = 'Closed';
    public static final String CASE_SUBJECT_PREFIX = 'Agentforce password reset - ';
    public static final String OUTCOME_LOCKED = 'LOCKED';

    // Settings record and defaults used only when the record is missing
    public static final String SETTING_RECORD = 'Default';
    private static final Integer DEFAULT_TTL_MINUTES = 10;
    private static final Integer DEFAULT_MAX_ATTEMPTS = 3;
    private static final Integer DEFAULT_MAX_SENDS = 3;
    private static final Integer DEFAULT_WINDOW_MINUTES = 15;
    private static final String DEFAULT_QUEUE = 'Password_Support';

    // Code generation: 6 digits, unbiased (S7)
    private static final Long CODE_SPACE = 1000000L;
    private static final Long INT_RANGE = 4294967296L;
    private static final Long UNSIGNED_MASK = 4294967295L;
    private static final Integer CODE_LENGTH = 6;
    private static final String PAD_CHARACTER = '0';
    private static final String HASH_ALGORITHM = 'SHA-256';
    private static final Integer TOKEN_KEY_BITS = 256;

    private static UC_Assist_Setting__mdt cachedSetting;
    private static Id cachedQueueId;
    private static Boolean queueLookedUp = false;

    /*****************************************************************
    Purpose:   Returns the Default settings record, with safe
               defaults if it is missing.
    Returns:   UC_Assist_Setting__mdt
    *****************************************************************/
    public static UC_Assist_Setting__mdt getSetting() {
        if (cachedSetting == null) {
            UC_Assist_Setting__mdt setting = UC_Assist_Setting__mdt.getInstance(SETTING_RECORD);

            if (setting == null) {
                setting = new UC_Assist_Setting__mdt(
                    Code_TTL_Minutes__c = DEFAULT_TTL_MINUTES,
                    Max_Attempts__c = DEFAULT_MAX_ATTEMPTS,
                    Max_Sends_Per_Hour__c = DEFAULT_MAX_SENDS,
                    Verification_Window_Minutes__c = DEFAULT_WINDOW_MINUTES,
                    Case_Queue_Developer_Name__c = DEFAULT_QUEUE
                );
            }
            cachedSetting = setting;
        }
        return cachedSetting;
    }

    /*****************************************************************
    Purpose:   Generates a 6-digit code with rejection sampling so
               every code is equally likely (S7).
    Returns:   String of exactly 6 digits
    *****************************************************************/
    public static String generateCode() {
        // Largest multiple of CODE_SPACE inside the 32-bit range
        Long acceptLimit = INT_RANGE - Math.mod(INT_RANGE, CODE_SPACE);
        Long candidate = acceptLimit;

        while (candidate >= acceptLimit) {
            candidate = ((Long) Crypto.getRandomInteger()) & UNSIGNED_MASK;
        }
        return String.valueOf(Math.mod(candidate, CODE_SPACE)).leftPad(CODE_LENGTH, PAD_CHARACTER);
    }

    /*****************************************************************
    Purpose:   Generates a random one-time verification token.
    Returns:   64-character hex string
    *****************************************************************/
    public static String generateToken() {
        return EncodingUtil.convertToHex(Crypto.generateAesKey(TOKEN_KEY_BITS));
    }

    /*****************************************************************
    Purpose:   SHA-256 hash of a code salted with the Contact Id.
    Parameters: code, contactId
    Returns:   64-character hex string
    *****************************************************************/
    public static String hashCode(String code, Id contactId) {
        return hashValue(code + String.valueOf(contactId));
    }

    /*****************************************************************
    Purpose:   SHA-256 hash of any value, as hex.
    Parameters: value
    Returns:   64-character hex string, or null for a blank value
    *****************************************************************/
    public static String hashValue(String value) {
        if (String.isBlank(value)) {
            return null;
        }
        return EncodingUtil.convertToHex(Crypto.generateDigest(HASH_ALGORITHM, Blob.valueOf(value)));
    }

    /*****************************************************************
    Purpose:   Finds the single eligible Contact for each email: a
               Contact that has a customer portal user (active or
               inactive). Zero or several matches mean "not found"
               (S6, V7).
    Parameters: emails - normalised (trimmed, lower case) addresses
    Returns:   Map of email to Contact Id, only for unique matches
    *****************************************************************/
    public static Map<String, Id> findEligibleContacts(Set<String> emails) {
        Map<String, Set<Id>> contactsByEmail = new Map<String, Set<Id>>();
        Map<String, Id> result = new Map<String, Id>();

        if (emails == null || emails.isEmpty()) {
            return result;
        }

        // One query for every request: portal users whose Contact has the email
        for (User portalUser : [
            SELECT ContactId, Contact.Email
            FROM User
            WHERE ContactId != null AND Contact.Email IN :emails
            WITH SYSTEM_MODE
            LIMIT 2000
        ]) {
            String email = normaliseEmail(portalUser.Contact.Email);

            if (!contactsByEmail.containsKey(email)) {
                contactsByEmail.put(email, new Set<Id>());
            }
            contactsByEmail.get(email).add(portalUser.ContactId);
        }

        for (String email : contactsByEmail.keySet()) {
            Set<Id> contactIds = contactsByEmail.get(email);

            if (contactIds.size() == 1) {
                result.put(email, new List<Id>(contactIds)[0]);
            }
        }
        return result;
    }

    /*****************************************************************
    Purpose:   Trims and lower-cases an email address.
    Parameters: email
    Returns:   normalised email, or empty string
    *****************************************************************/
    public static String normaliseEmail(String email) {
        return String.isBlank(email) ? '' : email.trim().toLowerCase();
    }

    /*****************************************************************
    Purpose:   Builds (does not insert) a password reset Case for an
               outcome. New Cases are owned by the support queue.
    Parameters: contactId, outcome (SUCCESS, LOCKED, ...), closed
    Returns:   Case ready to insert
    *****************************************************************/
    public static Case buildCase(Id contactId, String outcome, Boolean closed) {
        Case resetCase = new Case(
            ContactId = contactId,
            Origin = CASE_ORIGIN,
            Reason = CASE_REASON,
            Subject = CASE_SUBJECT_PREFIX + outcome,
            Status = closed ? CASE_STATUS_CLOSED : CASE_STATUS_NEW
        );
        Id queueId = getQueueId();

        if (!closed && queueId != null) {
            resetCase.OwnerId = queueId;
        }
        return resetCase;
    }

    /*****************************************************************
    Purpose:   Looks up the support queue by developer name from the
               settings record (no hard-coded Id).
    Returns:   Queue Id, or null if it does not exist
    *****************************************************************/
    public static Id getQueueId() {
        // Cached so callers can build many Cases without repeating the query
        if (!queueLookedUp) {
            String queueName = getSetting().Case_Queue_Developer_Name__c;
            List<Group> queues = [
                SELECT Id FROM Group
                WHERE Type = 'Queue' AND DeveloperName = :queueName
                WITH SYSTEM_MODE
                LIMIT 1
            ];
            cachedQueueId = queues.isEmpty() ? null : queues[0].Id;
            queueLookedUp = true;
        }
        return cachedQueueId;
    }
}
