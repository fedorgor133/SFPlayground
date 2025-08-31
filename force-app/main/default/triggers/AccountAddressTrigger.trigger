trigger AccountAddressTrigger on Account(before insert, before update){
    for(Account acc : Trigger.new){
        if(acc.Match_Billing_Address__c == true){
            acc.ShippingStreet = acc.BillingStreet;
            acc.ShippingCity = acc.BillingCity;
            acc.ShippingState = acc.BillingState;
            acc.ShippingPostalCode = acc.BillingPostalCode;
            acc.ShippingCountry = acc.BillingCountry;
        }
    }

}