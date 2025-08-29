trigger OpportunityPlaybookTrigger on Opportunity (after update) {
    List<Opportunity_Playbook_Item__c> itemsToInsert = new List<Opportunity_Playbook_Item__c>();

    for (Opportunity opp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);

        System.debug('Checking Opp: ' + opp.Id +
                     ' Old Stage=' + oldOpp.StageName +
                     ' New Stage=' + opp.StageName);

        if (opp.StageName != oldOpp.StageName) {
            System.debug('✅ Stage actually changed!');

            // Query matching Custom Metadata for this stage
            List<Opportunity_Playbook_Template__mdt> templates = [
                SELECT Task_Name__c, Task_Assignee__c, Task_Description__c
                FROM Opportunity_Playbook_Template__mdt
                WHERE Stage__c = :opp.StageName
            ];

            for (Opportunity_Playbook_Template__mdt t : templates) {
                itemsToInsert.add(new Opportunity_Playbook_Item__c(
                    Opportunity__c    = opp.Id,
                    Task_Name__c      = t.Task_Name__c,
                    Task_Assignee__c  = t.Task_Assignee__c,
                    Task_Description__c = t.Task_Description__c
                ));
            }
        }
    }

    if (!itemsToInsert.isEmpty()) {
        insert itemsToInsert;
        System.debug('Inserted ' + itemsToInsert.size() + ' playbook items ✅');
    }
}
