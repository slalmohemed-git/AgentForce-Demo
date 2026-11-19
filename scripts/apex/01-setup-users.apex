// Step 3a (setup objects only, so no mixed-DML): give the running admin the
// UC Account Owner role, create the UC Assist Agent user and assign the
// UC_Assist_Agent permission set group. Safe to re-run: skips what exists.
Id adminId = UserInfo.getUserId();
UserRole ucRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'UC_Account_Owner' LIMIT 1];
User admin = [SELECT Id, UserRoleId FROM User WHERE Id = :adminId];
if (admin.UserRoleId == null) { admin.UserRoleId = ucRole.Id; update admin; }

String agentUsername = 'ucassist.agent.e68b5eeb6b@example.com';
List<User> existing = [SELECT Id FROM User WHERE Username = :agentUsername LIMIT 1];
User agent;
if (existing.isEmpty()) {
    Profile agentProfile = [SELECT Id FROM Profile WHERE Name = 'Einstein Agent User' LIMIT 1];
    agent = new User(Username = agentUsername, FirstName = 'UC Assist', LastName = 'Agent',
        Alias = 'ucassist', Email = 'slalmohemed@gmail.com', ProfileId = agentProfile.Id,
        TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
    Database.DMLOptions noEmail = new Database.DMLOptions();
    noEmail.EmailHeader.triggerUserEmail = false;
    Database.insert(agent, noEmail);
} else { agent = existing[0]; }

PermissionSetGroup psg = [SELECT Id FROM PermissionSetGroup WHERE DeveloperName = 'UC_Assist_Agent' LIMIT 1];
if ([SELECT COUNT() FROM PermissionSetAssignment WHERE AssigneeId = :agent.Id AND PermissionSetGroupId = :psg.Id] == 0) {
    insert new PermissionSetAssignment(AssigneeId = agent.Id, PermissionSetGroupId = psg.Id);
}
System.debug('AGENT_USER_ID=' + agent.Id);
