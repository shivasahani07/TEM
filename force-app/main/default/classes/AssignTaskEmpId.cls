public with sharing class AssignTaskEmpId {
    @AuraEnabled
    public static void fetchDetails(){
        List<Jira_Task__c> query =[Select Id,Name,Module__c,Description__c,Task_Start_Date_Time__c,Task_End_Date_Time__c,Actual_Efforts__c,Module__r.Project__c 
                                   FROM Jira_Task__c];
        
        /*List<Time_Entry_Line_Items__c> myquery =[Select Id, Name, Time_Entry_Daily_Card__r.Time_Entry_Weekly_Card__r.Time_Entry_Monthly_Card__r.Employee__c
                                                 FROM Time_Entry_Line_Items__c 
                                                 Where Time_Entry_Daily_Card__r.Time_Entry_Weekly_Card__r.Time_Entry_Monthly_Card__r.Employee__r.Name = 'Shubham'];*/
    }
}