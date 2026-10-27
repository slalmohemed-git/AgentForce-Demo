/*****************************************************************
Name:          RedeemVerificationTokenTest
============================================================
Purpose:       Tests the server-side re-check: valid token, wrong
               Contact, stale, consumed, other session, bad input,
               and a bulk run.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 US-3
*****************************************************************/
@isTest
private class RedeemVerificationTokenTest {

    private static final String TOKEN = 'abc123token';

    @TestSetup
    static void setup() {
        User owner = VerificationTestDataFactory.createAccountOwner();

        System.runAs(owner) {
            VerificationTestDataFactory.createCustomers(20, false);
        }
    }

    // Builds a Verified code for a Contact with the given token
    private static Verification_Code__c verified(Id contactId, String token, String sessionId) {
        Verification_Code__c vc = VerificationTestDataFactory.buildSentCode(contactId, sessionId);
        vc.Status__c = VerificationCodeService.STATUS_VERIFIED;
        vc.Verified_At__c = System.now();
        vc.Verification_Token_Hash__c = VerificationCodeService.hashValue(token);
        return vc;
    }

    private static RedeemVerificationToken.Result redeemOne(String contactId, String token, String sessionId) {
        RedeemVerificationToken.Request req = new RedeemVerificationToken.Request();
        req.contactId = contactId;
        req.token = token;
        req.sessionId = sessionId;
        return RedeemVerificationToken.redeem(new List<RedeemVerificationToken.Request>{ req })[0];
    }

    // Valid token for the right Contact and session (15-char Id also accepted)
    @isTest
    static void validTokenRedeems() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = [SELECT Id FROM Contact LIMIT 1];
            Verification_Code__c vc = verified(customer.Id, TOKEN, VerificationTestDataFactory.SESSION_ID);
            insert vc;

            Test.startTest();
            RedeemVerificationToken.Result res = redeemOne(String.valueOf(customer.Id).left(15), TOKEN,
                VerificationTestDataFactory.SESSION_ID);
            Test.stopTest();

            System.assert(res.isValid, 'Valid token');
            System.assertEquals(String.valueOf(vc.Id), res.verificationCodeId, 'Code Id returned');
        }
    }

    // Every way the token can be wrong returns not valid
    @isTest
    static void invalidCasesFail() {
        System.runAs(VerificationTestDataFactory.tester()) {
            List<Contact> customers = [SELECT Id FROM Contact LIMIT 2];
            Verification_Code__c stale = verified(customers[0].Id, 'stale', null);
            stale.Verified_At__c = System.now().addMinutes(-16);
            Verification_Code__c consumed = verified(customers[0].Id, 'consumed', null);
            consumed.Status__c = VerificationCodeService.STATUS_CONSUMED;
            Verification_Code__c bound = verified(customers[0].Id, 'bound', VerificationTestDataFactory.SESSION_ID);
            Verification_Code__c good = verified(customers[0].Id, TOKEN, null);
            insert new List<Verification_Code__c>{ stale, consumed, bound, good };

            Test.startTest();
            System.assert(!redeemOne(customers[0].Id, 'stale', null).isValid, 'Stale fails');
            System.assert(!redeemOne(customers[0].Id, 'consumed', null).isValid, 'Consumed fails');
            System.assert(!redeemOne(customers[0].Id, 'bound', VerificationTestDataFactory.OTHER_SESSION_ID).isValid,
                'Other session fails');
            System.assert(!redeemOne(customers[1].Id, TOKEN, null).isValid, 'Wrong contact fails');
            System.assert(!redeemOne(customers[0].Id, 'not-a-token', null).isValid, 'Unknown token fails');
            System.assert(!redeemOne('not-an-id', TOKEN, null).isValid, 'Bad Id fails');
            System.assert(!redeemOne(customers[0].Id, '', null).isValid, 'Blank token fails');
            Test.stopTest();

            System.assertEquals(0, RedeemVerificationToken.redeem(null).size(), 'Null input handled');
        }
    }

    // 20 tokens redeemed in one call
    @isTest
    static void bulkRedeem() {
        System.runAs(VerificationTestDataFactory.tester()) {
            List<Verification_Code__c> codes = new List<Verification_Code__c>();
            List<RedeemVerificationToken.Request> requests = new List<RedeemVerificationToken.Request>();
            Integer i = 0;

            for (Contact customer : [SELECT Id FROM Contact]) {
                codes.add(verified(customer.Id, TOKEN + i, null));
                RedeemVerificationToken.Request req = new RedeemVerificationToken.Request();
                req.contactId = customer.Id;
                req.token = TOKEN + i;
                requests.add(req);
                i++;
            }
            insert codes;

            Test.startTest();
            List<RedeemVerificationToken.Result> results = RedeemVerificationToken.redeem(requests);
            Test.stopTest();

            System.assertEquals(20, results.size(), 'One result each');

            for (RedeemVerificationToken.Result res : results) {
                System.assert(res.isValid, 'Each valid');
            }
        }
    }
}
