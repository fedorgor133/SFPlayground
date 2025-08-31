# Salesforce Triggers and Features

## 📌 Opportunity Playbook  
The **Opportunity Playbook** automates task creation when an Opportunity stage changes, using templates stored in **Opportunity_Playbook_Template__mdt**. Tasks are tracked as **Opportunity_Playbook_Item__c** records, and an **Apex Trigger (OpportunityPlaybookTrigger)** ensures tasks are generated. A **Lightning Web Component** provides visibility and lets sales reps mark tasks as completed or re-run the playbook.  

## 📌 Account Address Trigger  
The **AccountAddressTrigger** runs **before insert and before update** on Account. When the **Match_Billing_Address__c** checkbox is selected, it automatically copies the Billing address fields (street, city, state, postal code, country) into the corresponding Shipping fields, ensuring data consistency.  

## 📌 Account Deletion Trigger  
The **AccountDeletion** trigger runs **before delete** on Account and prevents the deletion of any Account that has related **Opportunity** records. It enforces data integrity by adding an error message if such a deletion is attempted.  

## 📌 Add Related Record Trigger  
The **AddRelatedRecord** trigger runs **after insert and after update** on Account. It checks if an Account has existing **Opportunity** records, and if none exist, it creates a default **Opportunity** in the “Prospecting” stage with a close date one month out.  

## 📌 Contact Notification Trigger  
The **ContactNotificationTrigger** runs **after insert and after delete** on Contact. On insert, it counts the new records and uses the **CustomContactNotification** utility class to notify the current user, supporting real-time awareness of Contact activity.  
