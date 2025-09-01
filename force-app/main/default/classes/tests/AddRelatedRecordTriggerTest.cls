@isTest
private class AddRelatedRecordTriggerTest {
    @isTest
    static void testCreatesDefaultOpportunity() {
        Account acc = new Account(Name = 'Account With No Opps');
        insert acc;

        Opportunity opp = [SELECT Name, StageName, CloseDate, AccountId 
                           FROM Opportunity WHERE AccountId = :acc.Id LIMIT 1];
        System.assertEquals('Account With No Opps Opportunity', opp.Name);
        System.assertEquals('Prospecting', opp.StageName);
    }

    @isTest
    static void testDoesNotCreateIfOpportunityExists() {
        Account acc = new Account(Name = 'Account With Opps');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Existing Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id
        );
        insert opp;

        // Update should not add another opportunity
        acc.Name = 'Updated Account';
        update acc;

        Integer oppCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :acc.Id];
        System.assertEquals(1, oppCount, 'Should not create duplicate opportunity');
    }
}
