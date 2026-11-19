// Step 3b (data only): two test customer accounts and contacts, owned by the
// running admin (who now holds the UC Account Owner role). Safe to re-run.
Map<String, String> acctByEmail = new Map<String, String>{
    'slalmohemed+maria@gmail.com' => 'Lopez Freight',
    'slalmohemed+ken@gmail.com'   => 'Ito Logistics' };
Map<String, List<String>> nameByEmail = new Map<String, List<String>>{
    'slalmohemed+maria@gmail.com' => new List<String>{ 'Maria', 'Lopez' },
    'slalmohemed+ken@gmail.com'   => new List<String>{ 'Ken', 'Ito' } };
Set<String> have = new Set<String>();
for (Contact c : [SELECT Email FROM Contact WHERE Email IN :acctByEmail.keySet()]) { have.add(c.Email); }
Map<String, Account> newAccts = new Map<String, Account>();
for (String email : acctByEmail.keySet()) {
    if (!have.contains(email)) { newAccts.put(email, new Account(Name = acctByEmail.get(email))); }
}
insert newAccts.values();
List<Contact> newContacts = new List<Contact>();
for (String email : newAccts.keySet()) {
    newContacts.add(new Contact(FirstName = nameByEmail.get(email)[0], LastName = nameByEmail.get(email)[1],
        Email = email, AccountId = newAccts.get(email).Id));
}
insert newContacts;
System.debug('CONTACTS_CREATED=' + newContacts.size());
