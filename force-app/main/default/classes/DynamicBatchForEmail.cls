global class DynamicBatchForEmail implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Actual_End_Date__c, Expected_Start_Date__c, Expected_End_Date__c, Project__c, Actual_Start_Date__c, Name__c,'
            +'(SELECT Id, Name, Total_Utilised_Time__c, Total_Estimated_Effort__c, Stand_By_Resource__c, Project_Resource_Mapping__c, Project_Name__c, Project__c, Project__r.Name, Percentage_Level__c,'
            +' Module_Start_Date__c, Module_End_Time__c, Module_Description__c, Module_Completed_Formula__c, Milestones_Name__c, Milestone__c, Is_Completed__c, Anticipated_Hours__c, Anticipated_End_Date__c,'
            +'Actual_Estimated_Efforts__c  FROM Modules__r)  FROM Milestone__c';
        
        
        
        system.debug('query----->'+query);
        return Database.getQueryLocator(query);
        // collect the batches of records or objects to be passed to execute
    }
    
    global void execute(Database.BatchableContext BC, List<Milestone__c> milestones){
        // process each batch of records
        ProjectEmailPreparation.sendSteeringMeetingData(milestones);
    }    
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    
}