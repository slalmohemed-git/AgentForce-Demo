/*****************************************************************
Name:          SendVerificationCode
============================================================
Purpose:       UC Assist agent action "Send Verification Code".
               Emails a 6-digit one-time code to the single portal
               Contact whose email matches. Enforces the hourly send
               limit (S2), expires earlier Sent codes, stores only a
               hash, and always returns the same neutral message so
               the agent never reveals whether an email exists.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 US-1
*****************************************************************/
public with sharing class SendVerificationCode {

    public static final String NEUTRAL_MESSAGE =
        'If that email is on file, a 6-digit code has been sent. It expires in 10 minutes.';
    private static final String EMAIL_SUBJECT = 'Your UC verification code';
    private static final String EMAIL_BODY_START = 'Your Universal Containers code is ';
    private static final String EMAIL_BODY_END =
        '. It expires in 10 minutes. If you did not ask for it, ignore this email.';
    private static final Integer MINUTES_PER_HOUR = 60;

    // Last swallowed error, so tests can see why a send did not happen
    @TestVisible
    private static String lastError;

    /** Input from the agent. */
    public class Request {
        @InvocableVariable(required=true label='Email' description='Email address the customer gave for the UC Portal')
        public String email;

        @InvocableVariable(label='Session Id' description='Messaging session Id, used to bind the code to this conversation')
        public String sessionId;
    }

    /** Output to the agent. */
    public class Result {
        @InvocableVariable(label='Message' description='Neutral message to read back to the customer word for word')
        public String message;
    }

    /*****************************************************************
    Purpose:   Sends codes for every request in the list.
    Parameters: requests - one per customer email
    Returns:   one neutral Result per request, in the same order
    *****************************************************************/
    @InvocableMethod(label='Send Verification Code'
        description='Emails a 6-digit one-time code to the customer whose UC Portal email matches. Never reveals whether the email exists.')
    public static List<Result> send(List<Request> requests) {
        System.debug('Entering SendVerificationCode.send: ' + (requests == null ? 0 : requests.size()));
        List<Result> results = new List<Result>();

        if (requests == null) {
            return results;
        }

        for (Request req : requests) {
            Result res = new Result();
            res.message = NEUTRAL_MESSAGE;
            results.add(res);
        }

        Savepoint beforeSend = Database.setSavepoint();

        try {
            sendCodes(requests);
        } catch (Exception ex) {
            // Undo partial work; the customer still gets the neutral message
            Database.rollback(beforeSend);
            lastError = ex.getTypeName() + ': ' + ex.getMessage();
            System.debug(LoggingLevel.ERROR, 'SendVerificationCode failed: ' + lastError);
        }

        System.debug('Exiting SendVerificationCode.send: ' + results.size());
        return results;
    }

    /*****************************************************************
    Purpose:   Creates the code records and sends the emails.
    Parameters: requests
    *****************************************************************/
    private static void sendCodes(List<Request> requests) {
        UC_Assist_Setting__mdt setting = VerificationCodeService.getSetting();
        Integer maxSends = setting.Max_Sends_Per_Hour__c.intValue();
        Integer ttlMinutes = setting.Code_TTL_Minutes__c.intValue();
        Set<String> emails = new Set<String>();

        for (Request req : requests) {
            emails.add(VerificationCodeService.normaliseEmail(req.email));
        }

        Map<String, Id> contactByEmail = VerificationCodeService.findEligibleContacts(emails);

        if (contactByEmail.isEmpty()) {
            return;
        }

        Set<Id> contactIds = new Set<Id>(contactByEmail.values());
        Map<Id, Integer> sendsInLastHour = countRecentSends(contactIds);
        List<Verification_Code__c> liveCodes = [
            SELECT Id, Contact__c FROM Verification_Code__c
            WHERE Contact__c IN :contactIds
                AND Status__c = :VerificationCodeService.STATUS_SENT
            LIMIT 2000
        ];
        Set<Id> contactsGettingCode = new Set<Id>();
        List<Verification_Code__c> toExpire = new List<Verification_Code__c>();
        List<Verification_Code__c> toInsert = new List<Verification_Code__c>();
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        Id senderId = findSenderId(setting.Org_Wide_Email_Address__c);

        for (Request req : requests) {
            Id contactId = contactByEmail.get(VerificationCodeService.normaliseEmail(req.email));

            if (contactId == null) {
                continue;
            }

            Integer sent = sendsInLastHour.containsKey(contactId) ? sendsInLastHour.get(contactId) : 0;

            if (sent >= maxSends) {
                // Rate limit reached (S2): no email, same neutral reply
                continue;
            }
            sendsInLastHour.put(contactId, sent + 1);
            contactsGettingCode.add(contactId);

            String code = VerificationCodeService.generateCode();
            toInsert.add(new Verification_Code__c(
                Contact__c = contactId,
                Code_Hash__c = VerificationCodeService.hashCode(code, contactId),
                Expires_At__c = System.now().addMinutes(ttlMinutes),
                Attempts__c = 0,
                Status__c = VerificationCodeService.STATUS_SENT,
                Session_Id__c = req.sessionId
            ));
            emailsToSend.add(buildEmail(contactId, code, senderId));
        }

        // A new code expires every earlier Sent code for that Contact only
        for (Verification_Code__c old : liveCodes) {
            if (contactsGettingCode.contains(old.Contact__c)) {
                old.Status__c = VerificationCodeService.STATUS_EXPIRED;
                toExpire.add(old);
            }
        }
        update toExpire;
        insert toInsert;

        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }

    /*****************************************************************
    Purpose:   Counts codes created per Contact in the last hour.
    Parameters: contactIds
    Returns:   Map of Contact Id to count
    *****************************************************************/
    private static Map<Id, Integer> countRecentSends(Set<Id> contactIds) {
        Datetime oneHourAgo = System.now().addMinutes(-MINUTES_PER_HOUR);
        Map<Id, Integer> counts = new Map<Id, Integer>();

        for (AggregateResult row : [
            SELECT Contact__c contactId, COUNT(Id) total
            FROM Verification_Code__c
            WHERE Contact__c IN :contactIds AND CreatedDate >= :oneHourAgo
            GROUP BY Contact__c
        ]) {
            counts.put((Id) row.get('contactId'), (Integer) row.get('total'));
        }
        return counts;
    }

    /*****************************************************************
    Purpose:   Finds the verified org-wide address by its email (S8).
               System mode: the Einstein agent user cannot query
               OrgWideEmailAddress, and this is a config lookup only.
    Parameters: address - from the settings record
    Returns:   OrgWideEmailAddress Id, or null to use the default sender
    *****************************************************************/
    private static Id findSenderId(String address) {
        if (String.isBlank(address)) {
            return null;
        }
        List<OrgWideEmailAddress> senders = [
            SELECT Id FROM OrgWideEmailAddress
            WHERE Address = :address AND IsVerified = true
            WITH SYSTEM_MODE
            LIMIT 1
        ];
        return senders.isEmpty() ? null : senders[0].Id;
    }

    /*****************************************************************
    Purpose:   Builds the code email for one Contact.
    Parameters: contactId, code, senderId (may be null)
    Returns:   Messaging.SingleEmailMessage
    *****************************************************************/
    private static Messaging.SingleEmailMessage buildEmail(Id contactId, String code, Id senderId) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(contactId);
        message.setSaveAsActivity(false);
        message.setSubject(EMAIL_SUBJECT);
        message.setPlainTextBody(EMAIL_BODY_START + code + EMAIL_BODY_END);

        if (senderId != null) {
            message.setOrgWideEmailAddressId(senderId);
        }
        return message;
    }
}
