trigger JiraTaskTrigger on Jira_Task__c (after update ,after insert,before insert) {
    
    if(trigger.isUpdate && trigger.isAfter){
        //JiraTaskTriggerHelper.updateDailyLineItems(Trigger.newMap,Trigger.oldmap);
        //JiraTaskTriggerHelper.updateContactAvailablility(Trigger.newMap,Trigger.oldmap);    
        //EmailTriggerHelperClass.mailOnTaskGeneration(trigger.new);
    }
    if(trigger.isInsert && trigger.isAfter){
        EmailTriggerHelperClass.mailOnTaskGeneration(trigger.new);
    }
    if(trigger.isInsert && trigger.isAfter){
        updateModuleOnJiraTask.StartModule(Trigger.oldMap, Trigger.newMap);
    }
    
    if(trigger.isInsert && trigger.isAfter){
        updateModuleOnJiraTask.totalEstimatedValueOnModule(Trigger.new);
    }
    if(trigger.isInsert && trigger.isBefore){
        updateModuleOnJiraTask.preventPrevioudDate(Trigger.new);
        updateModuleOnJiraTask.checkjtConflictTiming(Trigger.new);
    }
    
}