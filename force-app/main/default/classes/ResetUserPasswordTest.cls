/*****************************************************************
Name:          ResetUserPasswordTest
============================================================
Purpose:       Tests Reset User Password, including spike R1: can
               the Einstein agent user reset a customer user's
               password? Also covers null input.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 US-2, R1
*****************************************************************/
@isTest
private class ResetUserPasswordTest {

    @TestSetup
    static void setup() {
        User owner = VerificationTestDataFactory.createAccountOwner();

        System.runAs(owner) {
            VerificationTestDataFactory.createCustomers(1, true);
        }
        VerificationTestDataFactory.createAgentUser();
    }

    private static List<ResetUserPassword.Request> requestFor(Id userId) {
        ResetUserPassword.Request req = new ResetUserPassword.Request();
        req.userId = userId;
        return new List<ResetUserPassword.Request>{ req };
    }

    // Admin context reset of an active portal user
    @isTest
    static void resetsPortalUser() {
        System.runAs(VerificationTestDataFactory.tester()) {
            User portalUser = [SELECT Id FROM User WHERE ContactId != null AND IsActive = true LIMIT 1];

            Test.startTest();
            List<ResetUserPassword.Result> results = ResetUserPassword.reset(requestFor(portalUser.Id));
            Test.stopTest();

            System.assert(results[0].isReset, 'Reset requested');
            System.assertEquals(0, ResetUserPassword.reset(null).size(), 'Null input handled');
        }
    }

    // Spike R1: the reset runs as the Einstein agent user
    @isTest
    static void agentUserCanReset() {
        System.runAs(VerificationTestDataFactory.tester()) {
            User portalUser = [SELECT Id FROM User WHERE ContactId != null AND IsActive = true LIMIT 1];
            User agent = [SELECT Id FROM User WHERE Profile.Name = 'Einstein Agent User' AND Alias = 'ucagent' LIMIT 1];
            List<ResetUserPassword.Result> results;

            Test.startTest();
            System.runAs(agent) {
                results = ResetUserPassword.reset(requestFor(portalUser.Id));
            }
            Test.stopTest();

            System.assert(results[0].isReset, 'Agent user can reset a portal password');
        }
    }
}
