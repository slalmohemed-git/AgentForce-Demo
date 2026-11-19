/*****************************************************************
Name:          VerificationCodeServiceTest
============================================================
Purpose:       Tests VerificationCodeService: code format and spread,
               hashing, eligible Contact matching (unique, duplicate,
               none) and Case building with queue ownership.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 tests
*****************************************************************/
@isTest
private class VerificationCodeServiceTest {

    @TestSetup
    static void setup() {
        User owner = VerificationTestDataFactory.createAccountOwner();

        System.runAs(owner) {
            VerificationTestDataFactory.createCustomers(2, true);
        }
    }

    // 200 codes are all 6 digits and not all the same
    @isTest
    static void generateCodeIsSixDigits() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Set<String> codes = new Set<String>();

            for (Integer i = 0; i < 200; i++) {
                String code = VerificationCodeService.generateCode();
                System.assertEquals(6, code.length(), 'Code must be 6 characters');
                System.assert(code.isNumeric(), 'Code must be digits only');
                codes.add(code);
            }
            System.assert(codes.size() > 150, 'Codes should be spread out');
        }
    }

    // Hash is stable, salted by Contact and never the plain code
    @isTest
    static void hashIsSaltedAndStable() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact first = [SELECT Id FROM Contact ORDER BY LastName LIMIT 1];
            Contact second = [SELECT Id FROM Contact ORDER BY LastName DESC LIMIT 1];
            String hashOne = VerificationCodeService.hashCode('111111', first.Id);

            System.assertEquals(64, hashOne.length(), 'SHA-256 hex is 64 characters');
            System.assertEquals(hashOne, VerificationCodeService.hashCode('111111', first.Id), 'Hash is stable');
            System.assertNotEquals(hashOne, VerificationCodeService.hashCode('111111', second.Id), 'Salted by Contact');
            System.assertEquals(null, VerificationCodeService.hashValue(''), 'Blank hashes to null');
            System.assertEquals(64, VerificationCodeService.generateToken().length(), 'Token is 64 hex chars');
        }
    }

    // Unique portal Contact is found; case and spaces do not matter
    @isTest
    static void findsUniqueContact() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = [SELECT Id, Email FROM Contact ORDER BY LastName LIMIT 1];
            String email = VerificationCodeService.normaliseEmail('  ' + customer.Email.toUpperCase() + ' ');
            Map<String, Id> found = VerificationCodeService.findEligibleContacts(new Set<String>{ email });

            System.assertEquals(customer.Id, found.get(email), 'Unique contact should match');
        }
    }

    // Two portal Contacts with one email are treated as not found (S6)
    @isTest
    static void duplicateEmailIsNotFound() {
        System.runAs(VerificationTestDataFactory.tester()) {
            List<Contact> customers = [SELECT Id, Email FROM Contact ORDER BY LastName];
            customers[1].Email = customers[0].Email;
            update customers[1];
            String email = VerificationCodeService.normaliseEmail(customers[0].Email);

            System.assert(VerificationCodeService.findEligibleContacts(new Set<String>{ email }).isEmpty(),
                'Duplicate email must not match');
            System.assert(VerificationCodeService.findEligibleContacts(new Set<String>()).isEmpty(),
                'Empty input returns nothing');
        }
    }

    // New Cases go to the queue, Closed ones keep the running user
    @isTest
    static void buildCaseUsesQueueForNew() {
        System.runAs(VerificationTestDataFactory.tester()) {
            Contact customer = [SELECT Id FROM Contact LIMIT 1];
            Case openCase = VerificationCodeService.buildCase(customer.Id, 'LOCKED', false);
            Case closedCase = VerificationCodeService.buildCase(customer.Id, 'SUCCESS', true);
            Id queueId = VerificationCodeService.getQueueId();

            System.assertNotEquals(null, queueId, 'Password Support queue must exist');
            System.assertEquals(queueId, openCase.OwnerId, 'New case owned by queue');
            System.assertEquals('New', openCase.Status, 'Open case is New');
            System.assertEquals('Closed', closedCase.Status, 'Success case is Closed');
            System.assertEquals('Password Reset', openCase.Reason, 'Reason set');
            System.assertEquals('Chat', openCase.Origin, 'Origin set');
            System.assertEquals(3, VerificationCodeService.getSetting().Max_Attempts__c.intValue(), 'Setting read');
        }
    }
}
