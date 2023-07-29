public class AccountTriggerHelper {
    public static void createMilestones(Map<Id, Account> newMap, Map<Id, Account> oldMap){
        set<Id> accountIds = new Set<Id>();
        List<Milestone__c> milestoneToInsertList = new List<Milestone__c>();
        List<Milestone__c> milestoneToDelete = new List<Milestone__c>();
                
        for(Account accRec : newMap.values()){
            if(accRec.Payment_Milestones__c != oldMap.get(accRec.Id).Payment_Milestones__c){
                accountIds.add(accRec.Id); 
            }
        }
        if(!accountIds.isEmpty()){
            for(Id accId : accountIds){
                if(newMap.containsKey(accId)){
                    for(integer i = 0 ; i< newMap.get(accId).Payment_Milestones__c; i++){
                        Milestone__c milestoneRec  = new Milestone__c();
                        milestoneRec.Account__c = accId;
                        milestoneToInsertList.add(milestoneRec);
                    }
                }
            }
            milestoneToDelete = [Select Id from Milestone__c where Account__c IN: accountIds];
            database.delete(milestoneToDelete);
            if(!milestoneToInsertList.isEmpty()){
                insert milestoneToInsertList;
            }
        }
    }
}