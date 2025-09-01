global class OpportunityReminderScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        OpportunityReminderBatch batch = new OpportunityReminderBatch();
        Database.executeBatch(batch, 200); // batch size 200
    }
}
