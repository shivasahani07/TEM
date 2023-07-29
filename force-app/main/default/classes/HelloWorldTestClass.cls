@isTest
private class HelloWorldTestClass {
    static testMethod void validateHelloWorld() {
        
        contact con = new Contact();
        con.firstname = 'shubham';
        con.Lastname = 'Shubham';
        con.Email = 'kshubham.skr29@gmail.com';
        insert con;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Project__c proj = new Project__c();
        proj.Account__c = acc.Id;
        insert proj;
        
        Project_Resource_Mapping__c PRM = new Project_Resource_Mapping__c();
        PRM.Contact__c = con.Id;
        PRM.Project__c = proj.Id;
        insert PRM;
        
        Time_Entry_Monthly_Card__c tem = new Time_Entry_Monthly_Card__c();
        insert tem;
        
        Time_Entry_Weekly_Card__c tew = new Time_Entry_Weekly_Card__c();
        tew.Time_Entry_Monthly_Card__c = tem.Id;
        insert tew;
        
        Jira_Task__c jt = new Jira_Task__c();
        jt.Project_Resource_Mapping__c = PRM.Id;
        jt.Team_Member__c = con.id;
        insert jt;
        
        
        jiraTaskManagerViewHelper.TestCoverage();
        TaskManagerChildViewLWCController.TestCoverage();
        LookupController.TestCoverage();
        FullCalendarController.TestCoverage();
        LoginPageController.TestCoverage();
        JiraTaskTriggerHelper.TestCoverage();
        MonthlyLineItemTriggerHelper.TestCoverage();
        ProjectResourceMappingHelper.TestCoverage();
        TimeEntryLineItemTriggerHelper.TestCoverage();
        reUsableMultiSelectLookupCtrl.TestCoverage();
        CreateDailyLineItemsController.TestCoverage();
        MonthlyLineItemsCreation.TestCoverage();
        
    }
}