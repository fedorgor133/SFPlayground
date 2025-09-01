@isTest
private class AccountAddressTriggerTest {
    @isTest
    static void testMatchBillingAddressTrue() {
        Account acc = new Account(
            Name = 'Test Account',
            BillingStreet = '123 Main St',
            BillingCity = 'Test City',
            BillingState = 'CA',
            BillingPostalCode = '12345',
            BillingCountry = 'USA',
            Match_Billing_Address__c = true
        );
        insert acc;

        Account inserted = [SELECT ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry 
                            FROM Account WHERE Id = :acc.Id];
        System.assertEquals('123 Main St', inserted.ShippingStreet);
        System.assertEquals('Test City', inserted.ShippingCity);
        System.assertEquals('CA', inserted.ShippingState);
        System.assertEquals('12345', inserted.ShippingPostalCode);
        System.assertEquals('USA', inserted.ShippingCountry);
    }

    @isTest
    static void testMatchBillingAddressFalse() {
        Account acc = new Account(
            Name = 'Test Account',
            BillingStreet = '456 Other St',
            Match_Billing_Address__c = false
        );
        insert acc;

        Account inserted = [SELECT ShippingStreet FROM Account WHERE Id = :acc.Id];
        System.assertEquals(null, inserted.ShippingStreet, 'Shipping address should not copy when checkbox is false');
    }
}
