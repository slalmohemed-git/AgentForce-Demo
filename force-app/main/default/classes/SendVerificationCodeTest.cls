/*****************************************************************
Name:          SendVerificationCodeTest
============================================================
Purpose:       Tests Send Verification Code: hash-only storage,
               neutral reply for unknown emails, hourly rate limit,
               expiry of earlier codes, bulk and agent-user runs.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 US-1
*****************************************************************/
@isTest
private class SendVerificationCodeTest {

    @TestSetup
    static void setup() {
        User owner = VerificationTestDataFactory.createAccountOwner();

        System.runAs(owner) {
            VerificationTestDataFactory.createCustomers(1, true);
            VerificationTestDataFactory.createCustomers(20, false);
        }
        VerificationTestDataFactory.createAgentUser();
    }

    private static SendVerificationCode.Request request(String email) {
        SendVerificationCode.Request req = new SendVerificationCode.Request();
        req.email = email;
        req.sessionId = VerificationTestDataFactory.SESSION_ID;
        return req;
    }

    private static Contact activeCustomer() {
        return [SELECT Id, Email FROM Contact WHERE Email LIKE '%a@uc-test.example.com' LIMIT 1];
    }

    // Known email: one Sent code, hashed, bound to the session, neutral reply
    @isTest
    static void knownEmailCreatesHashedCode() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = activeCustomer();

            Test.startTest();
            List<SendVerificationCode.Result> results =
                SendVerificationCode.send(new List<SendVerificationCode.Request>{ request(customer.Email) });
            Integer emailsSent = Limits.getEmailInvocations();
            Test.stopTest();

            Verification_Code__c vc = [
                SELECT Status__c, Code_Hash__c, Session_Id__c, Expires_At__c, Attempts__c
                FROM Verification_Code__c WHERE Contact__c = :customer.Id
            ];
            System.assertEquals(SendVerificationCode.NEUTRAL_MESSAGE, results[0].message, 'Neutral message');
            System.assertEquals('Sent', vc.Status__c, 'Status Sent');
            System.assertEquals(64, vc.Code_Hash__c.length(), 'Only a hash is stored');
            System.assertEquals(VerificationTestDataFactory.SESSION_ID, vc.Session_Id__c, 'Session bound');
            System.assert(vc.Expires_At__c > System.now().addMinutes(9), 'Expires in about 10 minutes');
            System.assertEquals(1, emailsSent, 'One email call');
        }
    }

    // Unknown email: same reply, nothing stored, nothing sent
    @isTest
    static void unknownEmailIsNeutral() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Test.startTest();
            List<SendVerificationCode.Result> results = SendVerificationCode.send(
                new List<SendVerificationCode.Request>{ request('stranger@example.com') });
            Test.stopTest();

            System.assertEquals(SendVerificationCode.NEUTRAL_MESSAGE, results[0].message, 'Same neutral reply');
            System.assertEquals(0, [SELECT COUNT() FROM Verification_Code__c], 'No code stored');
            System.assertEquals(0, SendVerificationCode.send(null).size(), 'Null input handled');
        }
    }

    // Four requests in an hour: three codes, only the newest still Sent
    @isTest
    static void rateLimitAndExpiry() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = activeCustomer();

            Test.startTest();

            for (Integer i = 0; i < 4; i++) {
                SendVerificationCode.send(new List<SendVerificationCode.Request>{ request(customer.Email) });
            }
            Test.stopTest();

            System.assertEquals(3, [SELECT COUNT() FROM Verification_Code__c WHERE Contact__c = :customer.Id],
                'Fourth send is blocked');
            System.assertEquals(1, [SELECT COUNT() FROM Verification_Code__c
                WHERE Contact__c = :customer.Id AND Status__c = 'Sent'], 'Only newest code is live');
            System.assertEquals(2, [SELECT COUNT() FROM Verification_Code__c
                WHERE Contact__c = :customer.Id AND Status__c = 'Expired'], 'Earlier codes expired');
        }
    }

    // 20 requests in one call: 14 inactive portal customers (V7 allows them) and
    // 6 unknown emails. 14 keeps the run inside the org's 15 emails per day.
    @isTest
    static void bulkSend() {
        System.runAs(VerificationTestDataFactory.tester()) {
            List<SendVerificationCode.Request> requests = new List<SendVerificationCode.Request>();

            for (Contact customer : [SELECT Email FROM Contact WHERE Email LIKE '%i@uc-test.example.com' LIMIT 14]) {
                requests.add(request(customer.Email));
            }

            for (Integer i = 0; i < 6; i++) {
                requests.add(request('stranger' + i + '@example.com'));
            }

            Test.startTest();
            List<SendVerificationCode.Result> results = SendVerificationCode.send(requests);
            Test.stopTest();

            System.assertEquals(null, SendVerificationCode.lastError, 'No error expected');
            System.assertEquals(20, results.size(), 'One result per request');
            System.assertEquals(14, [SELECT COUNT() FROM Verification_Code__c WHERE Status__c = 'Sent'],
                'One code per known customer, none for unknown emails');
        }
    }

    // Runs as the Einstein agent user with its permission sets
    @isTest
    static void runsAsAgentUser() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = activeCustomer();
            User agent = [SELECT Id FROM User WHERE Profile.Name = 'Einstein Agent User' AND Alias = 'ucagent' LIMIT 1];

            Test.startTest();
            System.runAs(agent) {
                SendVerificationCode.send(new List<SendVerificationCode.Request>{ request(customer.Email) });
            }
            Test.stopTest();

            System.assertEquals(null, SendVerificationCode.lastError, 'No error expected');
            System.assertEquals(1, [SELECT COUNT() FROM Verification_Code__c WHERE Contact__c = :customer.Id],
                'Agent user can create the code');
        }
    }
}
