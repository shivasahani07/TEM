public class updateModuleOnJiraTask {
    //Update the Start Task of module when the first Jira task is created..
    Public Static void StartModule(Map<Id, jira_Task__c> jtMapOld, Map<Id, jira_Task__c> jtMapNew){
        system.debug('jtMapOld::'+jtMapOld);
        system.debug('jtMapNew::'+jtMapNew);
        List<string> ModuleIds = new List<String>();
        map<string,List<jira_Task__c>> jiraTasksByModuleIds = new map<string,List<jira_Task__c>>();
        List<jira_Task__c> JirataskList = [Select id , name , module__c from jira_Task__c where module__c != null];
        
        for(jira_Task__c jt :JirataskList){
            if(jt.Module__c != null){
                if(jiraTasksByModuleIds.containsKey(jt.Module__c)){
                    jiraTasksByModuleIds.get(jt.Module__c).add(jt);
                }else{
                    List<jira_Task__c> jtnewList = new List<jira_Task__c>();
                    jtnewList.add(jt);
                    system.debug('jtnewList::'+jtnewList);
                    jiraTasksByModuleIds.put(jt.Module__c,jtnewList);
                }
            }
        }
        system.debug('jiraTasksByModuleIds'+jiraTasksByModuleIds);
        
        for(jira_Task__c jt : jtMapNew.values()){
            if(jiraTasksByModuleIds.get(jt.Module__c).size() > 1){
                system.debug('Sorry but Not the First Task');
            }else{
                system.debug('Update these module');
                ModuleIds.add(jt.Module__c);
            }
        }
        
        List<Module__c> moduleList = [Select id , name , Module_Start_Date__c,Milestone__r.Actual_Start_Date__c from Module__c where id in : ModuleIds];
        if(moduleList.size() > 0){
            for(Module__c mod : moduleList){
                if(mod.Module_Start_Date__c == Null){
                    mod.Module_Start_Date__c = system.today();
                    
                    system.debug('Module_Start_Date__c:::');
                }
            }
            
        }
        update moduleList;
        
    }
    
    Public Static List<Milestone__c> UpdateMilesstones(string projectiD){
        List<Milestone__c> MilestoneList=[select id,name,name__c,project__c from Milestone__c  where project__c =:projectiD];
        return MilestoneList;
        
    }
    
    //THIS METHOD WILL UPDATE TOTAL ESTIMATED HOURS ON ITS (FROM JIRA TASK)
    //CREATED BY SHIVA
    //DATE 2023-05-05  YYYY-MM-DD
    Public Static void totalEstimatedValueOnModule(List<Jira_task__c> newjTaskList){
        Map<Id, Decimal> ModuleIdbytoalHours = new Map<Id, Decimal>();
        list<String> ModuleIds= new List<String>();
        for(Jira_task__c jt:newjTaskList){
            if(jt.Module__c !=Null){
                ModuleIds.add(jt.Module__c);
            }
        }
        
        map<id,Module__c> modulesById= new  map<id,Module__c>([select id,name,Total_Utilised_Time__c,(select id,name,Estimated_Efforts_in_hour__c from Jira_tasks__r) from Module__c where id In:ModuleIds]);
        for(Module__c mdl:modulesById.values()){
            decimal totaljtHours =0;
            list<Jira_task__c> jtList=mdl.Jira_tasks__r;
            for(Jira_task__c jt:jtList){
                if(jt.Estimated_Efforts_in_hour__c !=null){
                    totaljtHours+=jt.Estimated_Efforts_in_hour__c;
                }
            }
            ModuleIdbytoalHours.put(mdl.Id,totaljtHours);
        }
        
        list<Module__c> moduleToBeUpdated = new list<Module__c>(); 
        for(id moduleID :ModuleIdbytoalHours.keyset()){
            Module__c Module= new Module__c (Id=moduleID, Total_Utilised_Time__c=ModuleIdbytoalHours.get(moduleID));
            moduleToBeUpdated.add(Module);
        }
        
        update moduleToBeUpdated;
    } 
    
    
    //PREVENT TO CREATE TASK FROM BACK DATES CANT LESS THEN TODAY
    //ADDES BY SHIVA UNDER SHUBHAM KUMAR
    //DATE 2023-05-17 YYYY-MM--DD
    
    Public Static void preventPrevioudDate(List<Jira_task__c> newjTaskList){
        for(Jira_task__c jt : newjTaskList){
            if(jt.Task_Start_Date_Time__c <system.today() && jt.Team_Member_Name__c!='Jishena Satish'){
                jt.AddError('Backdated tasks are not allowed..😂' );
            }
        }
    }
    
    //this method will check if team member has already a task 🕛 by Shiva
    
    Public static void checkjtConflictTiming(List<Jira_task__c> newjTaskList){
        
        map<String,List<Jira_task__c>> jtListbyTeammemberIdTodays = new  map<String,List<Jira_task__c>> ();
        map<String,List<Jira_task__c>> jtListbyTeammemberId = new  map<String,List<Jira_task__c>> ();
        List<Jira_task__c> jtToBeAdded =new List<Jira_task__c>();
        List<Jira_Task__c> allJtListTodays = [SELECT Id, Name, Estimated_Efforts_in_hour__c, Estimated_Start_Date__c,Task_End_Date_Time__c	, Actual_Task_Start_Time__c, Task_Start_Date_Time__c,Team_Member__c FROM Jira_Task__c WHERE Estimated_Start_Date__c =:System.today()];
        system.debug('allJtListTodays'+allJtListTodays);
        try{
            for(Jira_Task__c jtt:allJtListTodays){
                if(jtt.Team_Member__c !=null ){
                    for(Jira_Task__c jt :newjTaskList){
                        if(jtt.Team_Member__c==jt.Team_Member__c){
                            if(jt.Task_Start_Date_Time__c>jtt.Task_End_Date_Time__c){
                                jtToBeAdded.add(jt);
                            }else{
                                jt.addError('Sorry but task has already been allocated for this time duration!!');
                            }
                        }
                    }
                }
            }
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}