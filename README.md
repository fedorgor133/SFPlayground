# Opportunity Playbook Feature

## Overview
Automates task creation for Opportunities based on stage, ensuring sales reps follow standard processes. Tasks are tracked directly from the Opportunity record.

## Components
- **Custom Metadata (`Opportunity_Playbook_Template__mdt`)** – Stores task templates for each stage (Task Name, Description, Assignee).  
- **Custom Object (`Opportunity_Playbook_Item__c`)** – Stores tasks linked to Opportunities with a **Completed** checkbox.  
- **Apex Trigger (`OpportunityPlaybookTrigger`)** – Runs after Opportunity stage changes to create tasks from templates.  
- **Lightning Web Component (LWC)** – Displays tasks and allows marking them as completed or re-running the playbook.

## How It Works
1. Opportunity stage changes.  
2. Trigger queries matching templates for the new stage.  
3. Tasks are created and linked to the Opportunity.  
4. Users track progress via LWC.