trigger ClosedOpportunityTrigger on Opportunity(after insert, after update){
    List<Task> tasksToInsert = new List<Task>();

    for(Opportunity opp : Trigger.new){
        if(opp.StageName == 'Closed Won'){
            Task t = new Task(
                Subject = 'Closed Won Follow Up Task',
                WhatId = opp.Id
            );
            tasksToInsert.add(t);

        }

    }

    if(!tasksToInsert.isEmpty()){
        insert tasksToInsert;
    }

}