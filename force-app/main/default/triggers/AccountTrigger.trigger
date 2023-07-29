trigger AccountTrigger on Account (after update) {
    if(trigger.isUpdate && trigger.isafter){
        AccountTriggerHelper.createMilestones(trigger.newMap, trigger.oldMap);
    }
}