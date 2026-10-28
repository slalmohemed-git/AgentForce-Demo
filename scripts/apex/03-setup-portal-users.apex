// Step 3c (setup objects only): portal users on the UC Portal Customer profile.
// Maria stays active; Ken is created then deactivated (test T5). No welcome
// email is sent, so the 15/day single-email limit is kept for the tests.
Profile portal = [SELECT Id FROM Profile WHERE Name = 'UC Portal Customer' LIMIT 1];
Map<String, String> userByEmail = new Map<String, String>{
    'slalmohemed+maria@gmail.com' => 'maria.lopez.ucportal@example.com',
    'slalmohemed+ken@gmail.com'   => 'ken.ito.ucportal@example.com' };
Set<String> haveUser = new Set<String>();
for (User u : [SELECT Username FROM User WHERE Username IN :userByEmail.values()]) { haveUser.add(u.Username); }
List<User> toInsert = new List<User>();
for (Contact c : [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email IN :userByEmail.keySet()]) {
    String uname = userByEmail.get(c.Email);
    if (haveUser.contains(uname)) { continue; }
    toInsert.add(new User(Username = uname, ContactId = c.Id, ProfileId = portal.Id,
        FirstName = c.FirstName, LastName = c.LastName, Email = c.Email,
        Alias = (c.FirstName.left(1) + c.LastName).left(8).toLowerCase(),
        CommunityNickname = uname.substringBefore('@'),
        TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US'));
}
Database.DMLOptions noEmail = new Database.DMLOptions();
noEmail.EmailHeader.triggerUserEmail = false;
Database.insert(toInsert, noEmail);
List<User> ken = [SELECT Id, IsActive FROM User WHERE Username = 'ken.ito.ucportal@example.com' AND IsActive = true];
for (User u : ken) { u.IsActive = false; }
update ken;
System.debug('PORTAL_USERS_CREATED=' + toInsert.size());
