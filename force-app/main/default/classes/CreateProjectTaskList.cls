public class CreateProjectTaskList {

    @AuraEnabled
    public Static list<ProjectTaskListWrapper>   getDetails(string projectid, string contact,string teamLeadId,Date startDate,Date endDate){
        Map<Id,Jira_Task__c> jiraTaskByJiraIdMap 					= new Map<Id,Jira_Task__c>();
        Map<id,Time_Entry_Line_Items__c> timeEntryRecByJiraIdMap 	= new Map<id,Time_Entry_Line_Items__c>();
        list<Jira_Task__c> jiraTaskList 							= new list<Jira_Task__c>();
        list<ProjectTaskListWrapper> wrapperlist 					= new list<ProjectTaskListWrapper>();
        List<Time_Entry_Line_Items__c> timeEntryLineItemList 		= new List<Time_Entry_Line_Items__c>();
        
        timeEntryLineItemList = [Select id,Project__c,Jira_Task__c,Status__c, Is_Over_Due__c,Allocated_Hours__c,Consumed_Hours__c,
                                Time_Entry_Daily_Card__r.Time_Entry_Weekly_Card__r.Time_Entry_Monthly_Card__r.Company_Employee__c,
                                  Project_Resource_Mapping__c,Project_Resource_Mapping__r.Contact__r.Name
                                 from Time_Entry_Line_Items__c 
                                 where Time_Entry_Daily_Card__r.Time_Entry_Weekly_Card__r.Time_Entry_Monthly_Card__r.Company_Employee__c =: contact
                                 ] ;
        system.debug(timeEntryLineItemList);
        system.debug(projectid);
        system.debug(contact);    
        system.debug(startDate);
        system.debug(endDate);
        
        //startdate >: Jira_Task__r.Task_Start_Date_Time__c AND endDate <: Jira_Task__c.Task_Start_Date_Time__c
        
        jiraTaskList = [Select id,Module__c,Priority__c,Description__c,Estimated_Efforts__c,Actual_Efforts__c,Module__r.Project__c,Module__r.Project__r.Name,
                        Task_Start_Date_Time__c, Task_End_Date_Time__c,Name from Jira_Task__c
                        where  Module__r.Project__c =: projectid 
                       AND      Task_Start_Date_Time__c >: StartDate AND  Task_End_Date_Time__c <: endDate];  
                       system.debug('Jira list' +jiraTaskList);
        
                //   AND      Task_Start_Date_Time__c >: StartDate AND  Task_End_Date_Time__c <: endDate
        //Task_Start_Date_Time__c =: StartDate OR Task_End_Date_Time__c =: endDate OR
             //Task_End_Date_Time__c >: Task_Start_Date_Time__c 
             //Task_End_Date_Time__c => Task_Start_Date_Time__c  
            
        if(!timeEntryLineItemList.isEmpty()){
            for(Time_Entry_Line_Items__c telm :timeEntryLineItemList ){
                timeEntryRecByJiraIdMap.put(telm.Jira_Task__c,telm);
            }
        }
        if(!jiraTaskList.isEmpty()){
            for(Jira_Task__c jt : jiraTaskList){
                jiraTaskByJiraIdMap.put(jt.id, jt);
            }
        }
        if(!timeEntryRecByJiraIdMap.isEmpty()){
            for(Jira_Task__c jt : jiraTaskByJiraIdMap.values()){
                ProjectTaskListWrapper wr  = new ProjectTaskListWrapper();
                wr.JiraId = jt.name;
                wr.ModuleName = jt.Module__c;
                wr.TaskDescription = jt.Description__c;
                if(timeEntryRecByJiraIdMap.containsKey(jt.Id))
                    wr.TeamMember = timeEntryRecByJiraIdMap.get(jt.Id).Project_Resource_Mapping__r.Contact__r.Name;
                
                wr.ProjectName = jt.Module__r.Project__r.Name;
                if(timeEntryRecByJiraIdMap.containsKey(jt.Id)){
                    wr.EstimatedEffort = timeEntryRecByJiraIdMap.get(jt.Id).Allocated_Hours__c;
                    if(timeEntryRecByJiraIdMap.get(jt.Id).Consumed_Hours__c != null)
                        // In above line we are checking if consumed houre not null then we go further
                        wr.ActualEfforts = timeEntryRecByJiraIdMap.get(jt.Id).Consumed_Hours__c;
                    wr.IsOverDue = timeEntryRecByJiraIdMap.get(jt.Id).Is_Over_Due__c;
                    wr.Status = timeEntryRecByJiraIdMap.get(jt.Id).Status__c;
                }
                wrapperlist.add(wr);
                
            }
             system.debug('Actual Record is Wrapperlist ===>>' +wrapperlist );
                 system.debug('Actual Record is ===>>' +jiraTaskList );
        }
        return wrapperlist;
    } 
    public class ProjectTaskListWrapper{
        @AuraEnabled public String JiraId{get;set;}
        @AuraEnabled public String TeamMember{get;set;}
        @AuraEnabled public String ProjectName{get;set;}
        @AuraEnabled public String ModuleName{get;set;}
        @AuraEnabled public String TaskDescription{get;set;}
        @AuraEnabled public Decimal EstimatedEffort{get;set;}
        @AuraEnabled public Decimal ActualEfforts{get;set;}
        @AuraEnabled public String IsOverDue{get;set;}
        @AuraEnabled public String Status{get;set;}
    }
}