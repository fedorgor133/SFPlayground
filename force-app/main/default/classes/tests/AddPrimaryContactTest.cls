@isTest
public class AddPrimaryContactTest {
    @isTest
    static void testAddPrimaryContact() {
        List<Account> nyAccounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            nyAccounts.add(new Account(Name = 'NY Account ' + i, BillingState = 'NY'));
        }
        insert nyAccounts;

        List<Account> caAccounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            caAccounts.add(new Account(Name = 'CA Account ' + i, BillingState = 'CA'));
        }
        insert caAccounts;

        Contact baseContact = new Contact(LastName = 'Test Contact');

        // Enqueue the job for CA accounts
        Test.startTest();
        System.enqueueJob(new AddPrimaryContact(baseContact, 'CA'));
        Test.stopTest(); // Ensures the Queueable runs

        // Verify Contacts were inserted only for CA Accounts
        List<Contact> insertedContacts = [
            SELECT Id, AccountId 
            FROM Contact 
            WHERE LastName = 'Test Contact'
        ];

        System.assertEquals(50, insertedContacts.size(), 'Should insert 50 contacts for CA accounts');
    }
}
