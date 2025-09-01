public class EmailUtils {
    public static void sendMessage(AsyncApexJob job, Integer recordsProcessed) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { job.CreatedBy.Email });
        mail.setSubject('Batch Job Completed: ' + job.Id);
        mail.setPlainTextBody(
            'Hello,\n\n' +
            'Your batch job has completed.\n' +
            'Records Processed: ' + recordsProcessed + '\n' +
            'Status: ' + job.Status + '\n' +
            'Errors: ' + job.NumberOfErrors + '\n' +
            'Items Processed: ' + job.JobItemsProcessed + '/' + job.TotalJobItems
        );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
