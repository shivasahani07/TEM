trigger TriggerOnMilestones on Milestone__c (before insert,after insert,after update) {
    if(Trigger.isInsert && Trigger.isAfter){
        TriggerOnMilestonesHelper.updateProjectPrecentageLevel(Trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        TriggerOnMilestonesHelper.updateProjectPrecentageLevel(Trigger.new);
    }
    
}