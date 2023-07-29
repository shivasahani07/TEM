public class CreateMilestoneHelper {
    
    @AuraEnabled
    public static List<Milestone__c> getMilestones(String accountId){
        List<Milestone__c> milestoneList = new List<Milestone__c>();
        
        milestoneList = [Select Id, Name,Name__c, Account__c, Is_Collected__c, Milestone_Weightage__c, Tentative_Date_of_Payment__c, Milestone_Weightage_Rs__c 
                         From Milestone__c where Account__c =: accountId  ORDER BY Tentative_Date_of_Payment__c ASC NULLS FIRST];
        if(milestoneList.size() < 1){
            Milestone__c mileStoneRec = new Milestone__c();
            milestoneList.add(mileStoneRec);
        }
        system.debug('milestoneList-->'+milestoneList);
        return milestoneList;
    }
    
    @AuraEnabled
    public static string saveMilestones(List<Milestone__c> milestoneList){
        try{
            upsert milestoneList;
            return 'SUCCESS';
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}