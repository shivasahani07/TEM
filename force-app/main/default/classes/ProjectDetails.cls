public class ProjectDetails {
    
    Public Static Void ProjectDetails(String recordID){
        
        Project__c ProjectRecord=[SELECT Account__c,Active__c,Id,Name,Percentage_Level__c,Project_End_Date__c,Project_Start_Date__c,Resource_Price_Rate__c,Salesforce_Products__c,Type__c FROM Project__c WHERE ID =:recordID];
           
        Milestone__c[] milestonesList=[SELECT Account__c,Actual_End_Date__c,Actual_Start_Date__c,Anticipated_End_Date__c,Anticipated_Hours__c,Closed_the_Milesstone__c,Description__c,Expected_End_Date__c,Expected_Start_Date__c,Id,Is_Collected__c,Milestone_Weightage_Rs__c,Milestone_Weightage__c,Name,Name__c,Precentage__c,Project__c,RecordTypeId,Stages__c,Tentative_Date_of_Payment__c,Total_Utilised_Time__c FROM Milestone__c WHERE Project__c =:recordID];
        
        Module__c[] ModuleList=[SELECT Actual_Estimated_Efforts__c,Anticipated_End_Date__c,Anticipated_Hours__c,Conga_Auth__c,Id,Is_Completed__c,Milestones_Name__c,Milestone__c,Module_Completed_Formula__c,Module_Description__c,Module_End_Time__c,Module_Start_Date__c,Name,Percentage_Level__c,Project_Name__c,Project_Resource_Mapping__c,Project__c,Stand_By_Resource__c,Total_Estimated_Effort__c,Total_Utilised_Time__c FROM Module__c WHERE Project__c =:recordID];
        
    }
    
    
    
    
    
    
    public class CompleteProjectDetailsWrapper{
        @AuraEnabled
        Public Project__c ProjectRecord {get;set;}
        @AuraEnabled
        Public Milestone__c[] milestones {get;set;}
        @AuraEnabled
        Public Module__c[] modules {get;set;}
       	@AuraEnabled
        Public Jira_Task__c[] jiraTask {get;set;}
        
    }
    

}