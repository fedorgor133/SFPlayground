@isTest
private class ContactNotificationTriggerTest {
    @isTest
    static void testInsertNotification() {
        Contact con = new Contact(
            LastName = 'Test Contact',
            AccountId = (new Account(Name = 'Test Acc')).Id
        );

        insert con;

        // We can't assert actual notifications here (depends on CustomContactNotification implementation),
        // but this ensures trigger runs without error
        System.assertNotEquals(null, con.Id);
    }

    @isTest
    static void testDeleteTriggerPath() {
        Account acc = new Account(Name = 'Delete Test Acc');
        insert acc;
        Contact con = new Contact(LastName = 'Delete Contact', AccountId = acc.Id);
        insert con;

        Test.startTest();
        delete con;
        Test.stopTest();

        // Ensure contact was deleted without errors
        Integer countContacts = [SELECT COUNT() FROM Contact WHERE Id = :con.Id];
        System.assertEquals(0, countContacts);
    }
}
