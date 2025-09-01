public with sharing class AccountProcessor {
    
    @future//asynchronous
    public static void countContacts(List<Id> accountIds) {
        List<Account> accountsToUpdate = new List<Account>();

        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) cnt
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId //group the results by each Account
        ]) {

            accountsToUpdate.add(new Account(
                Id = (Id) ar.get('AccountId'),
                Number_Of_Contacts__c = (Integer) ar.get('cnt')
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
