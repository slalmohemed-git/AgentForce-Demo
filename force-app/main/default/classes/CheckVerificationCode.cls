/*****************************************************************
Name:          CheckVerificationCode
============================================================
Purpose:       UC Assist agent action "Check Verification Code".
               Checks the code the customer typed against the latest
               unexpired Sent code for their portal Contact. On
               success it marks the code Verified and issues a
               one-time verification token (stored only as a hash).
               Wrong codes count attempts; the last allowed attempt
               locks the code and logs a Case for the support queue.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 US-1, US-5
*****************************************************************/
public with sharing class CheckVerificationCode {

    public static final String MESSAGE_FAILED =
        'That code did not work. Please check it or ask for a new one.';
    public static final String MESSAGE_LOCKED =
        'Too many attempts. Please request a new code or ask to speak with our team.';
    public static final String MESSAGE_VERIFIED = 'Thanks, you are verified.';

    /** Input from the agent. */
    public class Request {
        @InvocableVariable(required=true label='Email' description='Email address the customer gave for the UC Portal')
        public String email;

        @InvocableVariable(required=true label='Code' description='6-digit code the customer typed')
        public String code;

        @InvocableVariable(label='Session Id' description='Messaging session Id of this conversation')
        public String sessionId;
    }

    /** Output to the agent. */
    public class Result {
        @InvocableVariable(label='Is Verified' description='True only for a correct, unexpired, unlocked code')
        public Boolean isVerified = false;

        @InvocableVariable(label='Is Locked' description='True when this attempt locked the code')
        public Boolean isLocked = false;

        @InvocableVariable(label='Verified Contact Id' description='Contact Id of the verified customer')
        public String contactId = '';

        @InvocableVariable(label='Verification Token' description='One-time token proving this verification')
        public String verificationToken = '';

        @InvocableVariable(label='Message' description='Message to read back to the customer')
        public String message = MESSAGE_FAILED;
    }

    /*****************************************************************
    Purpose:   Checks every request in the list.
    Parameters: requests
    Returns:   one Result per request, in the same order
    *****************************************************************/
    @InvocableMethod(label='Check Verification Code'
        description='Checks a one-time code. Returns Is Verified true only for a correct, unexpired, unlocked code.')
    public static List<Result> check(List<Request> requests) {
        System.debug('Entering CheckVerificationCode.check: ' + (requests == null ? 0 : requests.size()));
        List<Result> results = new List<Result>();

        if (requests == null) {
            return results;
        }

        for (Request req : requests) {
            results.add(new Result());
        }

        Savepoint beforeCheck = Database.setSavepoint();

        try {
            checkCodes(requests, results);
        } catch (Exception ex) {
            // Fail closed: nobody is verified if anything goes wrong
            Database.rollback(beforeCheck);
            results.clear();

            for (Request req : requests) {
                results.add(new Result());
            }
            System.debug(LoggingLevel.ERROR, 'CheckVerificationCode failed: ' + ex.getMessage());
        }

        System.debug('Exiting CheckVerificationCode.check: ' + results.size());
        return results;
    }

    /*****************************************************************
    Purpose:   Does the checking and writes the outcomes.
    Parameters: requests, results (filled in place)
    *****************************************************************/
    private static void checkCodes(List<Request> requests, List<Result> results) {
        Integer maxAttempts = VerificationCodeService.getSetting().Max_Attempts__c.intValue();
        Set<String> emails = new Set<String>();

        for (Request req : requests) {
            emails.add(VerificationCodeService.normaliseEmail(req.email));
        }

        Map<String, Id> contactByEmail = VerificationCodeService.findEligibleContacts(emails);
        Map<Id, Verification_Code__c> latestByContact = new Map<Id, Verification_Code__c>();
        Map<Id, Verification_Code__c> toUpdate = new Map<Id, Verification_Code__c>();
        Set<Id> contactIds = new Set<Id>(contactByEmail.values());
        Datetime now = System.now();

        // Newest first, so the first live code per Contact is the one to check
        for (Verification_Code__c vc : [
            SELECT Id, Contact__c, Code_Hash__c, Attempts__c, Expires_At__c, Session_Id__c, Status__c
            FROM Verification_Code__c
            WHERE Contact__c IN :contactIds AND Status__c = :VerificationCodeService.STATUS_SENT
            ORDER BY CreatedDate DESC
            LIMIT 2000
        ]) {
            if (vc.Expires_At__c == null || vc.Expires_At__c <= now) {
                // Lazy expiry keeps the audit trail accurate (S5)
                vc.Status__c = VerificationCodeService.STATUS_EXPIRED;
                toUpdate.put(vc.Id, vc);
            } else if (!latestByContact.containsKey(vc.Contact__c)) {
                latestByContact.put(vc.Contact__c, vc);
            }
        }

        Map<Integer, Case> lockCases = new Map<Integer, Case>();

        for (Integer i = 0; i < requests.size(); i++) {
            Request req = requests[i];
            Result res = results[i];
            Id contactId = contactByEmail.get(VerificationCodeService.normaliseEmail(req.email));
            Verification_Code__c vc = contactId == null ? null : latestByContact.get(contactId);

            if (vc == null || vc.Status__c != VerificationCodeService.STATUS_SENT) {
                continue;
            }

            Boolean sameSession = String.isBlank(vc.Session_Id__c) || vc.Session_Id__c == req.sessionId;
            String typed = req.code == null ? '' : req.code.trim();

            if (sameSession && vc.Code_Hash__c == VerificationCodeService.hashCode(typed, contactId)) {
                String token = VerificationCodeService.generateToken();
                vc.Status__c = VerificationCodeService.STATUS_VERIFIED;
                vc.Verified_At__c = now;
                vc.Verification_Token_Hash__c = VerificationCodeService.hashValue(token);
                res.isVerified = true;
                res.contactId = contactId;
                res.verificationToken = token;
                res.message = MESSAGE_VERIFIED;
            } else {
                vc.Attempts__c = (vc.Attempts__c == null ? 0 : vc.Attempts__c) + 1;

                if (vc.Attempts__c >= maxAttempts) {
                    vc.Status__c = VerificationCodeService.STATUS_LOCKED;
                    res.isLocked = true;
                    res.message = MESSAGE_LOCKED;
                    lockCases.put(i, VerificationCodeService.buildCase(
                        contactId, VerificationCodeService.OUTCOME_LOCKED, false));
                }
            }
            toUpdate.put(vc.Id, vc);
        }

        // Every lockout is logged for the support queue (C2)
        if (!lockCases.isEmpty()) {
            insert lockCases.values();

            for (Integer i : lockCases.keySet()) {
                Id contactId = contactByEmail.get(VerificationCodeService.normaliseEmail(requests[i].email));
                latestByContact.get(contactId).Case__c = lockCases.get(i).Id;
            }
        }
        update toUpdate.values();
    }
}
