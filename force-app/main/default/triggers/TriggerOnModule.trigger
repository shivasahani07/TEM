trigger TriggerOnModule on Module__c (after update,after insert,before insert,before update) {
	if(trigger.isAfter && trigger.isInsert){
        TriggerOnModuleHelper.updateMilesStones(Trigger.new);
    }
    if(trigger.isAfter && trigger.isupdate){
        TriggerOnModuleHelper.twotestupdateModule(Trigger.new);
       TriggerOnModuleHelper.updateMilesStones(Trigger.new);

    }
}