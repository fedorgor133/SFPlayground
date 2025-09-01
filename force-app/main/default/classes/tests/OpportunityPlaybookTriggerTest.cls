@isTest
private class OpportunityPlaybookTriggerTest {

    @testSetup
    static void setupData() {
        // Create an Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Create an Opportunity linked to the account
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id
        );
        insert opp;

        // Insert Custom Metadata Templates for stages
        // Note: Custom Metadata cannot be inserted in normal Apex; in test context, use Metadata API or mock
        // For simplicity, assume at least one template exists for 'Qualification' stage
    }

    @isTest
    static void testStageChangeCreatesPlaybookItems() {
        // Retrieve the opportunity
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];

        Test.startTest();
        // Change the stage
        opp.StageName = 'Qualification';
        update opp;
        Test.stopTest();

        // Verify playbook items were created
        List<Opportunity_Playbook_Item__c> items = [
            SELECT Id, Opportunity__c, Task_Name__c 
            FROM Opportunity_Playbook_Item__c 
            WHERE Opportunity__c = :opp.Id
        ];

        System.assert(items.size() > 0, 'Playbook items should be created when stage changes');
    }

    @isTest
    static void testNoItemsIfStageUnchanged() {
        // Retrieve the opportunity
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];

        Test.startTest();
        // Update without changing the stage
        opp.Name = 'Updated Opportunity Name';
        update opp;
        Test.stopTest();

        // Verify no new playbook items were created
        List<Opportunity_Playbook_Item__c> items = [
            SELECT Id, Opportunity__c 
            FROM Opportunity_Playbook_Item__c 
            WHERE Opportunity__c = :opp.Id
        ];

        System.assert(items.size() == 0, 'No playbook items should be created if stage does not change');
    }
}
