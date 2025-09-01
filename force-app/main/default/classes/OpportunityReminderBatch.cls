public class OpportunityReminderBatch implements Database.Batchable<SObject>, Database.Stateful{
    // preserve instance variables between executions of this batch job: Stateful
    Integer daysBeforeClose;
    Integer daysSinceUpdate;

    public OpportunityReminderBatch() {
        // Load from Custom Metadata (fallback defaults if missing)
        Opportunity_Reminder__mdt config = Opportunity_Reminder__mdt.getInstance('Default');
        daysBeforeClose = (config != null && config.Days_Before_Close__c != null) ? 
                          Integer.valueOf(config.Days_Before_Close__c) : 7;
        daysSinceUpdate = (config != null && config.Days_Since_Update__c != null) ? 
                          Integer.valueOf(config.Days_Since_Update__c) : 5;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.today();
        return Database.getQueryLocator([
            SELECT Id, Name, CloseDate, LastModifiedDate, OwnerId
            FROM Opportunity
            WHERE CloseDate <= :today.addDays(daysBeforeClose)
              AND LastModifiedDate <= :today.addDays(-daysSinceUpdate)
              AND IsClosed = false
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> oppList) {
        List<Task> tasks = new List<Task>();
        for (Opportunity opp : oppList) {
            tasks.add(new Task(
                OwnerId = opp.OwnerId,
                WhatId = opp.Id,
                Subject = 'Reminder: Opportunity needs update',
                ActivityDate = Date.today(),
                Priority = 'High',
                Status = 'Not Started',
                Description = 'Please update Opportunity "' + opp.Name + '" before it closes.'
            ));
        }
        if (!tasks.isEmpty()) insert tasks;
    }

    public void finish(Database.BatchableContext bc) {
        // Optional: Send summary email to Admin
    }
}