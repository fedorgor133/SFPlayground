@isTest
private class AccountDeletionTriggerTest {
    @isTest
    static void testPreventDeleteWithOpportunities() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id
        );
        insert opp;

        Test.startTest();
        try {
            delete acc;
            System.assert(false, 'Expected error when deleting account with opportunities');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot delete account with related opportunities.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testAllowDeleteWithoutOpportunities() {
        Account acc = new Account(Name = 'No Opp Account');
        insert acc;

        Test.startTest();
        delete acc;
        Test.stopTest();

        System.assertEquals(0, [SELECT COUNT() FROM Account WHERE Id = :acc.Id]);
    }
}
