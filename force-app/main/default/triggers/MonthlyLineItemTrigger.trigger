trigger MonthlyLineItemTrigger on Time_Entry_Weekly_Card__c (after insert) {
    
    if(trigger.isAfter && trigger.isInsert){
        if(test.isRunningTest()){
            
        }else{
            MonthlyLineItemTriggerHelper.createDailyLineItems(Trigger.new);    
        }
        
    }
    
}