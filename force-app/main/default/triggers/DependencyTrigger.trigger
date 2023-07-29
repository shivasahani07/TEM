trigger DependencyTrigger on Dependency__c (after insert) {
    if(Trigger.isInsert && trigger.isAfter){
        DependencyTriggerHelper.onDependencyCreation(Trigger.new);
    }
}