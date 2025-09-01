@isTest
public class AccountProcessorTest {
    
    @isTest
    static void testCountContacts() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        List<Contact> cons = new List<Contact>{
            new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id),
            new Contact(FirstName = 'Jane', LastName = 'Smith', AccountId = acc.Id)
        };
        insert cons;

        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{acc.Id});
        Test.stopTest();

        Account updatedAcc = [SELECT Number_Of_Contacts__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2, updatedAcc.Number_Of_Contacts__c, 'Account should have 2 contacts');
    }

    @isTest
    static void testNoContacts() {
        Account acc2 = new Account(Name = 'No Contact Account');
        insert acc2;

        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{acc2.Id});
        Test.stopTest();

        // Query account again (it should not have updates, field remains null or 0)
        Account updatedAcc2 = [SELECT Number_Of_Contacts__c FROM Account WHERE Id = :acc2.Id];
        System.assertEquals(0, updatedAcc2.Number_Of_Contacts__c, 'Account should have 0 contacts');
    }
}
