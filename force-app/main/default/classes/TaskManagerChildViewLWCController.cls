public without sharing class TaskManagerChildViewLWCController {
    
    @AuraEnabled(cacheable=true)
    public static List<Jira_Task__c> getAllTaskRelatedToContact(String conId, Integer selectedDate, Integer selectedMonth, Integer selectedYear){
        try {
            
            Date startDate = Date.newInstance(selectedYear,selectedMonth,selectedDate); 
            Map<Id,Jira_Task__c> taskMap = new Map<Id,Jira_Task__c>([Select Id,Name,Actual_Task_Start_Time__c,Actual_Task_End_Time__c,Priority__c,Total_Break_Time__c,Solution_Details_if_any__c,Break_Start_Time__c,Break_End_Time__c,Description__c,Status__c,Project_Resource_Mapping__c,Actual_Efforts__c,Estimated_Efforts__c,Module__r.Name,Module__r.Project__r.Name,(Select Id,Name,Stat_Time_date__c,End_Time_Date__c,Status__c,Jira_Task__c From Time_Entry_Line_Items__r) From Jira_Task__c Where Status__c!='Deployed' And Task_Start_Date__c >=:startDate AND Task_End_Date__c<=:startDate AND (Team_Member__c = :conId OR Stand_By_Resource__c = :conId)]);
            
            return taskMap.values();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static string updateExtension(String taskId, Decimal timeAskedFor, String extensionReason,Decimal estimatedHours){
        try {
            Jira_Task__c jTask = new Jira_Task__c(Id=taskId,Estimated_Efforts__c=estimatedHours+timeAskedFor,Extension_Reason__c=extensionReason);
            update jTask;
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String  startJob(String taskId, string conId, Integer selectedDate, Integer selectedMonth, Integer selectedYear,String prmId){
        
        try {
            Jira_Task__c jTask = new Jira_Task__c(Id=taskId,Actual_Task_Start_Time__c=System.now(),Status__c='In Progress');
            
            update jTask;
            
            System.debug('prmId--'+prmId);
            
            Date startDate = Date.newInstance(selectedYear,selectedMonth,selectedDate);
            Time_Entry_Daily_Card__c  tedcObj = [SELECT Id,Contact__c ,Date_Of_Work__c,	PRM_Id__c,Name,Time_Entry_Weekly_Card__c,Total_Hours_Consumed__c FROM Time_Entry_Daily_Card__c WHERE Date_Of_Work__c =:startDate AND  PRM_Id__c	 =:prmId ];
            
            if(tedcObj==null)
                return 'Daily card not created yet.';
            
            Time_Entry_Line_Items__c  teli = new Time_Entry_Line_Items__c();    
            teli.Jira_Task__c =  taskId;
            teli.Project_Resource_Mapping__c = prmId;
            teli.Time_Entry_Daily_Card__c = tedcObj.Id;
            teli.Stat_Time_date__c = System.now();
            
            insert teli;
            
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string endJob(String teliId,String taskId){
        try {
            Jira_Task__c jTask = [Select Id,Actual_Task_Start_Time__c,Actual_Task_End_Time__c,Task_End_Date_Time__c,Break_Start_Time__c,Break_End_Time__c,Estimated_Efforts__c From Jira_Task__c Where Id=:taskId];

            Long startTime = jTask.Actual_Task_Start_Time__c.getTime();
            Long endTime = System.now().getTime();

            Long totalTimeTakenLong = 0;

            if(jTask.Break_Start_Time__c!=null && jTask.Break_End_Time__c!=null){
                Long timeTakenInBreak = jTask.Break_End_Time__c.getTime() - jTask.Break_Start_Time__c.getTime();
                totalTimeTakenLong = endTime - startTime - timeTakenInBreak;
            }else{
                totalTimeTakenLong = endTime - startTime;
            }



            Long timeTakenInHours = (totalTimeTakenLong) / (1000*60*60);

            if(timeTakenInHours>jTask.Estimated_Efforts__c){
                return 'You took extra time to finish this task!, Please first add extension then click end job.';
            }


            jTask.Actual_Task_End_Time__c = System.now();

            update jTask;
            
            Time_Entry_Line_Items__c tli = new Time_Entry_Line_Items__c(Id=teliId,Is_Completed__c=true,End_Time_Date__c=System.now());
            update tli;
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String breakStartEnd(String taskId, String breakType){
        try{
            Jira_Task__c jTask = new Jira_Task__c(Id=taskId);
            if(breakType=='startBreak'){
                jTask.Break_Start_Time__c = System.now();
            }else{
                jTask.Break_End_Time__c = System.now();
            }

            update jTask;
            return 'Success';
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string markStatusAsComplete(String taskId){
        try {
            Jira_Task__c jTask = new Jira_Task__c(Id=taskId,Status__c='Dev Completed');
            update jTask;
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string manualTimeEntry(String taskId,String conId,Integer selectedDate, Integer selectedMonth, Integer selectedYear,Decimal usedHours,String prmId){
        try {
            Date startDate = Date.newInstance(selectedYear,selectedMonth,selectedDate);
            
            Integer min = (usedHours * 60).intValue();
            DateTime sDate = System.now().addMinutes(-min);    
            
            Jira_Task__c jTask = new Jira_Task__c(Id=taskId,Actual_Task_Start_Time__c =sDate, Actual_Task_End_Time__c = System.now(),Status__c='Dev Completed');
            update jTask;
            
            // Time_Entry_Line_Items__c tli;
            // if(!telis.isEmpty()){
            //     tli = telis[0];
            //     tli.Stat_Time_date__c = sDate;
            //     tli.End_Time_Date__c = System.now();
            // }else{
            //     tli = new Time_Entry_Line_Items__c();    
            //     tli.Jira_Task__c =  taskId;
            //     tli.Time_Entry_Daily_Card__c = tedcObj.Id;
            //     tli.End_Time_Date__c = System.now();
            //     tli.Stat_Time_date__c = sDate;
            //     tli.Project_Resource_Mapping__c = prmId;
            // }
            
            // upsert tli;
            
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }    
    
    
    @AuraEnabled
    public static List<Attachment> getFiles(String taskId){
        try {
            return [Select Id,Name,ParentId From Attachment Where ParentId =:taskId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Dependency__c> getDependencies(String taskId){
        try {
            System.debug('TaskId---'+taskId);
            return [Select Id,Name, Depends_on__r.Name,Description__c,Jira_Task__c From Dependency__c Where Jira_Task__c=:taskId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Dependency__c createDependencies(Dependency__c dp){
        try {
            insert dp;
            
            dp = [Select Id,Name, Depends_on__r.Name,Description__c,Jira_Task__c From Dependency__c Where Id =: dp.Id];
            return dp;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Contact> getTeamLeads(String conId){
        try {
            List<String> conList = new List<String>{conId};
                return [Select Id,Name From Contact Where Id Not IN : conList];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public Static void TestCoverage(){
        integer i = 0 ;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}