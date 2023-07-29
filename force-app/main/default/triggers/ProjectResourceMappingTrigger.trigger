trigger ProjectResourceMappingTrigger on Project_Resource_Mapping__c (after insert) {
    
    if(Trigger.isafter && Trigger.isinsert){
        ProjectResourceMappingHelper.creatingMonthlyTimeSheet(trigger.New);
    }
    
}