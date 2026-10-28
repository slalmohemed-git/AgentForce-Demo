/*****************************************************************
Name:          CheckVerificationCodeTest
============================================================
Purpose:       Tests Check Verification Code: correct code and token,
               wrong code, lockout with Case, expiry, other session,
               unknown email, bulk and agent-user runs.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 US-1, US-5
*****************************************************************/
@isTest
private class CheckVerificationCodeTest {

    @TestSetup
    static void setup() {
        User owner = VerificationTestDataFactory.createAccountOwner();
        List<Contact> customers;

        System.runAs(owner) {
            customers = VerificationTestDataFactory.createCustomers(1, true);
            VerificationTestDataFactory.createCustomers(20, false);
        }
        VerificationTestDataFactory.createAgentUser();

        System.runAs(owner) {
            insert VerificationTestDataFactory.buildSentCode(customers[0].Id, VerificationTestDataFactory.SESSION_ID);
        }
    }

    private static CheckVerificationCode.Request request(String email, String code, String sessionId) {
        CheckVerificationCode.Request req = new CheckVerificationCode.Request();
        req.email = email;
        req.code = code;
        req.sessionId = sessionId;
        return req;
    }

    private static Contact activeCustomer() {
        return [SELECT Id, Email FROM Contact WHERE Email LIKE '%a@uc-test.example.com' LIMIT 1];
    }

    private static CheckVerificationCode.Result checkOne(String email, String code, String sessionId) {
        return CheckVerificationCode.check(
            new List<CheckVerificationCode.Request>{ request(email, code, sessionId) })[0];
    }

    // Correct code: Verified, token issued and stored only as hash
    @isTest
    static void correctCodeVerifies() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = activeCustomer();

            Test.startTest();
            CheckVerificationCode.Result res = checkOne(customer.Email, ' 123456 ', VerificationTestDataFactory.SESSION_ID);
            Test.stopTest();

            Verification_Code__c vc = [SELECT Status__c, Verified_At__c, Verification_Token_Hash__c
                FROM Verification_Code__c WHERE Contact__c = :customer.Id];
            System.assert(res.isVerified, 'Should verify');
            System.assertEquals(String.valueOf(customer.Id), res.contactId, 'Contact returned');
            System.assertEquals('Verified', vc.Status__c, 'Status Verified');
            System.assertNotEquals(null, vc.Verified_At__c, 'Verified At set');
            System.assertEquals(VerificationCodeService.hashValue(res.verificationToken),
                vc.Verification_Token_Hash__c.toLowerCase(), 'Token stored as hash');
        }
    }

    // Wrong code three times: Locked, Case for the queue, no verification
    @isTest
    static void threeWrongCodesLock() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = activeCustomer();
            CheckVerificationCode.Result res;

            Test.startTest();

            for (Integer i = 0; i < 3; i++) {
                res = checkOne(customer.Email, VerificationTestDataFactory.WRONG_CODE, VerificationTestDataFactory.SESSION_ID);
            }
            Test.stopTest();

            Verification_Code__c vc = [SELECT Status__c, Attempts__c, Case__c, Case__r.OwnerId, Case__r.Reason
                FROM Verification_Code__c WHERE Contact__c = :customer.Id];
            System.assert(!res.isVerified, 'Never verified');
            System.assert(res.isLocked, 'Locked flag');
            System.assertEquals(CheckVerificationCode.MESSAGE_LOCKED, res.message, 'Locked message');
            System.assertEquals('Locked', vc.Status__c, 'Status Locked');
            System.assertEquals(3, vc.Attempts__c, 'Three attempts');
            System.assertEquals(VerificationCodeService.getQueueId(), vc.Case__r.OwnerId, 'Case owned by queue');
            System.assertEquals('Password Reset', vc.Case__r.Reason, 'Case reason');
            // A correct code after lockout no longer works
            System.assert(!checkOne(customer.Email, VerificationTestDataFactory.KNOWN_CODE,
                VerificationTestDataFactory.SESSION_ID).isVerified, 'Locked code is dead');
        }
    }

    // One wrong code only counts an attempt
    @isTest
    static void wrongCodeCountsAttempt() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = activeCustomer();

            Test.startTest();
            CheckVerificationCode.Result res = checkOne(customer.Email, VerificationTestDataFactory.WRONG_CODE,
                VerificationTestDataFactory.SESSION_ID);
            Test.stopTest();

            System.assertEquals(CheckVerificationCode.MESSAGE_FAILED, res.message, 'Failure message');
            System.assertEquals(1, [SELECT Attempts__c FROM Verification_Code__c WHERE Contact__c = :customer.Id].Attempts__c,
                'One attempt');
        }
    }

    // Expired code is marked Expired and does not verify
    @isTest
    static void expiredCodeFails() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = activeCustomer();
            Verification_Code__c vc = [SELECT Id FROM Verification_Code__c WHERE Contact__c = :customer.Id];
            vc.Expires_At__c = System.now().addMinutes(-1);
            update vc;

            Test.startTest();
            CheckVerificationCode.Result res = checkOne(customer.Email, VerificationTestDataFactory.KNOWN_CODE,
                VerificationTestDataFactory.SESSION_ID);
            Test.stopTest();

            System.assert(!res.isVerified, 'Expired code fails');
            System.assertEquals('Expired', [SELECT Status__c FROM Verification_Code__c WHERE Id = :vc.Id].Status__c,
                'Lazily expired');
        }
    }

    // Right code from another chat session does not verify (S3)
    @isTest
    static void otherSessionFails() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = activeCustomer();

            Test.startTest();
            CheckVerificationCode.Result res = checkOne(customer.Email, VerificationTestDataFactory.KNOWN_CODE,
                VerificationTestDataFactory.OTHER_SESSION_ID);
            Test.stopTest();

            System.assert(!res.isVerified, 'Other session fails');
        }
    }

    // Unknown email and null input
    @isTest
    static void unknownEmailFails() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Test.startTest();
            CheckVerificationCode.Result res = checkOne('stranger@example.com', '123456', null);
            Test.stopTest();

            System.assert(!res.isVerified, 'Unknown email fails');
            System.assertEquals(CheckVerificationCode.MESSAGE_FAILED, res.message, 'Same failure message');
            System.assertEquals(0, CheckVerificationCode.check(null).size(), 'Null input handled');
        }
    }

    // 20 customers checked in one call
    @isTest
    static void bulkCheck() {
        System.runAs(VerificationTestDataFactory.tester()) {
            List<Contact> customers = [SELECT Id, Email FROM Contact WHERE Email LIKE '%i@uc-test.example.com'];
            List<Verification_Code__c> codes = new List<Verification_Code__c>();
            List<CheckVerificationCode.Request> requests = new List<CheckVerificationCode.Request>();

            for (Contact customer : customers) {
                codes.add(VerificationTestDataFactory.buildSentCode(customer.Id, null));
                requests.add(request(customer.Email, VerificationTestDataFactory.KNOWN_CODE, null));
            }
            insert codes;

            Test.startTest();
            List<CheckVerificationCode.Result> results = CheckVerificationCode.check(requests);
            Test.stopTest();

            System.assertEquals(20, results.size(), 'One result each');

            for (CheckVerificationCode.Result res : results) {
                System.assert(res.isVerified, 'Each verifies');
            }
        }
    }

    // Runs as the Einstein agent user (it must see its own codes)
    @isTest
    static void runsAsAgentUser() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = activeCustomer();
            User agent = [SELECT Id FROM User WHERE Profile.Name = 'Einstein Agent User' AND Alias = 'ucagent' LIMIT 1];
            CheckVerificationCode.Result res;

            System.runAs(agent) {
                insert VerificationTestDataFactory.buildSentCode(customer.Id, VerificationTestDataFactory.OTHER_SESSION_ID);
                Test.startTest();
                res = checkOne(customer.Email, VerificationTestDataFactory.KNOWN_CODE, VerificationTestDataFactory.OTHER_SESSION_ID);
                Test.stopTest();
            }
            System.assert(res.isVerified, 'Agent user can verify');
        }
    }
}
