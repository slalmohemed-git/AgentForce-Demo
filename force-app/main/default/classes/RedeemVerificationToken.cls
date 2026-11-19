/*****************************************************************
Name:          RedeemVerificationToken
============================================================
Purpose:       Server-side re-check used by the SUB - Reset Portal
               Password flow (layer 3 of the gate). A token is valid
               only if its hash matches a Verified code for the same
               Contact, from the same session (when the code has
               one), verified within the verification window, and
               not already Consumed. It does not consume the token;
               the flow does that after a successful reset.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 US-3, V2
*****************************************************************/
public with sharing class RedeemVerificationToken {

    /** Input from the flow. */
    public class Request {
        @InvocableVariable(label='Contact Id' description='Verified Contact Id from the agent')
        public String contactId;

        @InvocableVariable(label='Verification Token' description='One-time token issued by Check Verification Code')
        public String token;

        @InvocableVariable(label='Session Id' description='Messaging session Id of this conversation')
        public String sessionId;
    }

    /** Output to the flow. */
    public class Result {
        @InvocableVariable(label='Is Valid' description='True only when the verification can be used for a reset')
        public Boolean isValid = false;

        @InvocableVariable(label='Verification Code Id' description='Id of the matching Verification Code record')
        public String verificationCodeId = '';
    }

    /*****************************************************************
    Purpose:   Validates every request in the list.
    Parameters: requests
    Returns:   one Result per request, in the same order
    *****************************************************************/
    @InvocableMethod(label='Redeem Verification Token'
        description='Checks that a verification token is genuine, recent, unused and for this Contact and session.')
    public static List<Result> redeem(List<Request> requests) {
        System.debug('Entering RedeemVerificationToken.redeem: ' + (requests == null ? 0 : requests.size()));
        List<Result> results = new List<Result>();

        if (requests == null) {
            return results;
        }

        Integer windowMinutes = VerificationCodeService.getSetting().Verification_Window_Minutes__c.intValue();
        Datetime earliest = System.now().addMinutes(-windowMinutes);
        Set<String> hashes = new Set<String>();

        for (Request req : requests) {
            String tokenHash = VerificationCodeService.hashValue(req.token);

            if (tokenHash != null) {
                hashes.add(tokenHash);
            }
        }

        Map<String, Verification_Code__c> codeByHash = new Map<String, Verification_Code__c>();

        for (Verification_Code__c vc : [
            SELECT Id, Contact__c, Status__c, Verified_At__c, Session_Id__c, Verification_Token_Hash__c
            FROM Verification_Code__c
            WHERE Verification_Token_Hash__c IN :hashes
            LIMIT 2000
        ]) {
            codeByHash.put(vc.Verification_Token_Hash__c.toLowerCase(), vc);
        }

        for (Request req : requests) {
            Result res = new Result();
            String tokenHash = VerificationCodeService.hashValue(req.token);
            Verification_Code__c vc = tokenHash == null ? null : codeByHash.get(tokenHash.toLowerCase());

            if (vc != null
                && vc.Status__c == VerificationCodeService.STATUS_VERIFIED
                && String.valueOf(vc.Contact__c) == toId18(req.contactId)
                && (String.isBlank(vc.Session_Id__c) || vc.Session_Id__c == req.sessionId)
                && vc.Verified_At__c != null
                && vc.Verified_At__c >= earliest) {
                res.isValid = true;
                res.verificationCodeId = vc.Id;
            }
            results.add(res);
        }

        System.debug('Exiting RedeemVerificationToken.redeem: ' + results.size());
        return results;
    }

    /*****************************************************************
    Purpose:   Converts a 15 or 18 character Id string to 18 chars.
    Parameters: value
    Returns:   18-character Id, or empty string when not an Id
    *****************************************************************/
    private static String toId18(String value) {
        if (String.isBlank(value)) {
            return '';
        }

        try {
            return String.valueOf(Id.valueOf(value.trim()));
        } catch (StringException ex) {
            // Not a valid Id: never matches a record
            return '';
        }
    }
}
