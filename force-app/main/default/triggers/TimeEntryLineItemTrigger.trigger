trigger TimeEntryLineItemTrigger on Time_Entry_Line_Items__c (before insert,after update) {
    
    if(trigger.isBefore && trigger.isInsert){
        //TimeEntryLineItemTriggerHelper.getDataFromJira(Trigger.new);    
    }
    
}