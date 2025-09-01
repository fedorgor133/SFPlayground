public class AddPrimaryContact implements Queueable {
    private Contact baseContact;
    private String stateAbbreviation;

    public AddPrimaryContact(Contact c, String stateAbbreviation) {
        this.baseContact = c;
        this.stateAbbreviation = stateAbbreviation;
    }

    public void execute(QueueableContext context) {
        // Query up to 200 Accounts for the given state
        List<Account> accounts = [
            SELECT Id, Name 
            FROM Account 
            WHERE BillingState = :stateAbbreviation
            LIMIT 200
        ];

        List<Contact> contactsToInsert = new List<Contact>();

        for (Account acc : accounts) {
            Contact clonedContact = baseContact.clone(false, true, false, false); //makes a shallow clone, preserves field values, but avoids copying IDs
            clonedContact.AccountId = acc.Id;
            contactsToInsert.add(clonedContact);
        }

        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}
