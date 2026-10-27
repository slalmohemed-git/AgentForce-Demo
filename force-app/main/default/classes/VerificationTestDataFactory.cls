/*****************************************************************
Name:          VerificationTestDataFactory
============================================================
Purpose:       Test data for the UC Assist password reset tests.
               Builds an account owner with a role, customer
               Accounts, Contacts and portal users, the Einstein
               agent user with its permission sets, and Verification
               Code records with a known code. No real org data.
============================================================
History
-------
VERSION  AUTHOR             DATE         DETAIL    DESCRIPTION
1.0      Revecast Orchestrate 27/10/2026 Created   Spec v1.0 tests
*****************************************************************/
@isTest
public class VerificationTestDataFactory {

    public static final String KNOWN_CODE = '123456';
    public static final String WRONG_CODE = '654321';
    public static final String SESSION_ID = '0Mw000000000001AAA';
    public static final String OTHER_SESSION_ID = '0Mw000000000002AAA';
    public static final String EMAIL_DOMAIN = '@uc-test.example.com';
    private static final String PORTAL_PROFILE = 'UC Portal Customer';
    private static final String ADMIN_PROFILE = 'System Administrator';
    private static final String AGENT_PROFILE = 'Einstein Agent User';
    private static final String LOCALE = 'en_US';
    private static final String TIME_ZONE = 'America/Los_Angeles';
    private static final String EMAIL_ENCODING = 'UTF-8';

    /*****************************************************************
    Purpose:   Creates an admin with a role who can own portal accounts.
    Returns:   inserted User
    *****************************************************************/
    public static User createAccountOwner() {
        UserRole role = new UserRole(Name = 'UC Test Account Owner');
        insert role;
        User owner = buildUser(ADMIN_PROFILE, 'ucowner');
        owner.UserRoleId = role.Id;
        insert owner;
        // Apex 68.0 runs DML in user mode, so the tester needs the data permission set
        PermissionSet dataAccess = [SELECT Id FROM PermissionSet WHERE Name = 'DATA_Identity_Verification_CRU' LIMIT 1];
        insert new PermissionSetAssignment(AssigneeId = owner.Id, PermissionSetId = dataAccess.Id);
        return owner;
    }

    /*****************************************************************
    Purpose:   Returns the test account owner created in test setup,
               used as the running user for every test.
    Returns:   User
    *****************************************************************/
    public static User tester() {
        return [SELECT Id FROM User WHERE Alias = 'ucowner' AND IsActive = true LIMIT 1];
    }

    /*****************************************************************
    Purpose:   Creates the Einstein agent user with the two UC Assist
               permission sets, so tests run as the real agent identity.
    Returns:   inserted User
    *****************************************************************/
    public static User createAgentUser() {
        User agent = buildUser(AGENT_PROFILE, 'ucagent');
        insert agent;
        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();

        for (PermissionSet ps : [
            SELECT Id FROM PermissionSet
            WHERE Name IN ('DATA_Identity_Verification_CRU', 'APP_UC_Assist_Agent')
        ]) {
            assignments.add(new PermissionSetAssignment(AssigneeId = agent.Id, PermissionSetId = ps.Id));
        }
        insert assignments;
        return agent;
    }

    /*****************************************************************
    Purpose:   Creates customers: Account, Contact and portal user each.
               Call inside System.runAs(accountOwner).
    Parameters: count, active (portal user active or not)
    Returns:   inserted Contacts, with Email populated
    *****************************************************************/
    public static List<Contact> createCustomers(Integer count, Boolean active) {
        List<Account> accounts = new List<Account>();

        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(Name = 'UC Test Customer ' + i));
        }
        insert accounts;

        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < count; i++) {
            contacts.add(new Contact(
                AccountId = accounts[i].Id,
                FirstName = 'Test',
                LastName = 'Customer' + i,
                Email = 'customer' + i + (active ? 'a' : 'i') + EMAIL_DOMAIN
            ));
        }
        insert contacts;

        Id portalProfileId = [SELECT Id FROM Profile WHERE Name = :PORTAL_PROFILE LIMIT 1].Id;
        List<User> portalUsers = new List<User>();

        for (Integer i = 0; i < count; i++) {
            User portalUser = buildUser(null, 'ucportal' + i + (active ? 'a' : 'i'));
            portalUser.ProfileId = portalProfileId;
            portalUser.ContactId = contacts[i].Id;
            portalUser.Email = contacts[i].Email;
            portalUser.IsActive = active;
            portalUsers.add(portalUser);
        }
        insert portalUsers;
        return contacts;
    }

    /*****************************************************************
    Purpose:   Builds a Sent code with KNOWN_CODE for a Contact.
    Parameters: contactId, sessionId
    Returns:   unsaved Verification_Code__c
    *****************************************************************/
    public static Verification_Code__c buildSentCode(Id contactId, String sessionId) {
        return new Verification_Code__c(
            Contact__c = contactId,
            Code_Hash__c = VerificationCodeService.hashCode(KNOWN_CODE, contactId),
            Expires_At__c = System.now().addMinutes(10),
            Attempts__c = 0,
            Status__c = VerificationCodeService.STATUS_SENT,
            Session_Id__c = sessionId
        );
    }

    /*****************************************************************
    Purpose:   Builds an unsaved User with a unique username.
    Parameters: profileName (may be null), alias seed
    Returns:   User
    *****************************************************************/
    public static User buildUser(String profileName, String seed) {
        String unique = seed + String.valueOf(Crypto.getRandomInteger()).replace('-', 'n');
        User newUser = new User(
            Username = unique + EMAIL_DOMAIN,
            Email = unique + EMAIL_DOMAIN,
            LastName = seed,
            Alias = seed.left(8),
            TimeZoneSidKey = TIME_ZONE,
            LocaleSidKey = LOCALE,
            EmailEncodingKey = EMAIL_ENCODING,
            LanguageLocaleKey = LOCALE
        );

        if (profileName != null) {
            newUser.ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;
        }
        return newUser;
    }
}
