/*****************************************************************
Name:          ResetUserPassword
============================================================
Purpose:       Flow action used by SUB - Reset Portal Password.
               Resets a portal user's password and lets Salesforce
               email them the reset link. Only ever called after the
               flow has redeemed a valid verification token.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 US-2
*****************************************************************/
public with sharing class ResetUserPassword {

    private static final Boolean SEND_RESET_EMAIL = true;

    /** Input from the flow. */
    public class Request {
        @InvocableVariable(required=true label='User Id' description='Id of the active portal user to reset')
        public Id userId;
    }

    /** Output to the flow. */
    public class Result {
        @InvocableVariable(label='Is Reset' description='True when the reset was requested successfully')
        public Boolean isReset = false;
    }

    /*****************************************************************
    Purpose:   Resets the password for every requested user.
    Parameters: requests
    Returns:   one Result per request; exceptions go to the flow fault path
    *****************************************************************/
    @InvocableMethod(label='Reset User Password'
        description='Resets a portal user password and emails them a reset link.')
    public static List<Result> reset(List<Request> requests) {
        System.debug('Entering ResetUserPassword.reset: ' + (requests == null ? 0 : requests.size()));
        List<Result> results = new List<Result>();

        if (requests == null) {
            return results;
        }

        for (Request req : requests) {
            Result res = new Result();
            // Not DML or SOQL; any failure is thrown so the flow takes its fault path
            System.resetPassword(req.userId, SEND_RESET_EMAIL);
            res.isReset = true;
            results.add(res);
        }

        System.debug('Exiting ResetUserPassword.reset: ' + results.size());
        return results;
    }
}
