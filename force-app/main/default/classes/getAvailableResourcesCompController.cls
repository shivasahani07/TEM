global  without sharing class getAvailableResourcesCompController {
    @AuraEnabled
    Public static  List<String> getResourcesAvaiability(){
        List<Jira_Task__c> jiraTaskList = new List<Jira_Task__c>();
        set<string> candidateWithNOTask = new set<string>();
        List<contact> coList = new    List<contact>();
        coList=[select id ,name from contact];
        
        Contact conRec = new Contact ();
        
        map<String, List<Jira_Task__c>> jiraTaskByConlist = new  map<String, List<Jira_Task__c>> ();
        date today=system.today();
        
        
        List<Jira_Task__c> jiraTaskListInProgress = [SELECT Actual_Efforts__c,Project_Name__c,Estimated_Start_Date__c,Total_Utilised_Time__c,Team_Member_Name__c,Module_Name__c,Stand_By_Resource_Name__c,CreatedById,Team_Member__r.Name,CreatedDate,Description__c,Estimated_Efforts__c,Extension_Reason__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Module__c,Is_Overdue__c,Assigned_By_Name__c,Name,OwnerId,Priority__c,Project_Resource_Mapping__c,Solution_Details_if_any__c,Status__c,SystemModstamp,Task_End_Date_Time__c,Current_Time__c,Task_Start_Date_Time__c,Task_Start_Date__c,Team_Member__c FROM Jira_Task__c where Estimated_Start_Date__c =:today and status__c= 'In progress'];
        
        jiraTaskList = [SELECT Actual_Efforts__c,Project_Name__c,Estimated_Start_Date__c,Total_Utilised_Time__c,Team_Member_Name__c,Module_Name__c,Stand_By_Resource_Name__c,CreatedById,Team_Member__r.Name,CreatedDate,Description__c,Estimated_Efforts__c,Extension_Reason__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Module__c,Is_Overdue__c,Assigned_By_Name__c,Name,OwnerId,Priority__c,Project_Resource_Mapping__c,Solution_Details_if_any__c,Status__c,SystemModstamp,Task_End_Date_Time__c,Task_Start_Date_Time__c,Task_Start_Date__c,Team_Member__c FROM Jira_Task__c where Estimated_Start_Date__c =:today and status__c= 'New'];
        
        system.debug('jiraTaskList++++++++++++++'+jiraTaskListInProgress.size());
        for(Jira_Task__c jt :jiraTaskListInProgress){
            system.debug('jt.Current_Time__c'+jt.Current_Time__c +':::::::::::::::::::::::::::::'+ jt.Estimated_Efforts__c);
            if(jt.Current_Time__c > jt.Estimated_Efforts__c){
                candidateWithNOTask.add(jt.Team_Member__r.Name);
            }
        }
        
        for(Jira_Task__c jt :jiraTaskList){
            candidateWithNOTask.add(jt.Team_Member__r.Name);
        }
        
        system.debug('candidateWithNOTask'+candidateWithNOTask);
        List<String> listStrings = new List<String>(candidateWithNOTask);
        return listStrings;
    }
    
    
    
    @AuraEnabled
    public Static List<contact> getAvailiableResource(){
        map<contact ,list<Project_Resource_Mapping__c>> mapListByContact = new map<contact ,list<Project_Resource_Mapping__c>>();
        map<id,Contact> conIdsBycontactRec = new map<id,Contact>();
        List<contact> avaialbleConList=[select id,name,Role__c,Email,Status__c from contact where Status__c= 'Available'];
        for(contact con : avaialbleConList){
            conIdsBycontactRec.put(con.Id,con);
        }
        List<Project_Resource_Mapping__c>  prmList = [SELECT Name,Project__c,Type__c,Contact__c FROM Project_Resource_Mapping__c where Contact__c In : avaialbleConList];
        
        
        for(Project_Resource_Mapping__c prm : prmList ){
            if(mapListByContact.containsKey(conIdsBycontactRec.get(prm.Contact__c))){
                mapListByContact.get(conIdsBycontactRec.get(prm.Contact__c)).add(prm);
            }else{
                List<Project_Resource_Mapping__c> prmListNew = new List<Project_Resource_Mapping__c>();
                prmListNew.add(prm);
                mapListByContact.put(conIdsBycontactRec.get(prm.Contact__c) , prmListNew);
            }
        }
        return avaialbleConList;
    }
    @AuraEnabled
    public Static List<Project_Resource_Mapping__c> getPRMLIST(String conId){
        system.debug('conId---'+conId);
        List<Project_Resource_Mapping__c>  prmList = [SELECT Name,Project__r.Name,Type__c,Contact__c FROM Project_Resource_Mapping__c where Contact__c = : conId];
        system.debug('prmList-----'+prmList);
        return prmList;
    }
    
    
    
    
    
    
    public static Map<String, String> picklistValues() {
        String objectName ='contact';
        String fieldName='Statuc__c';
        Map<String, String> values = new Map<String, String>{};
            List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(new List<String>{objectName});
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {
                    values.put(entry.getValue(), entry.getLabel());
                }
            }
        }
        system.debug('values---'+values);
        return values;
    }
    
    @AuraEnabled
    public static List<String> accountPicklist(){
        String objName ='contact';
        String fldName='Statuc__c';
        List<String> pkList = new List<String>();
        Map<String,Schema.SObjectType> allObj = Schema.getGlobalDescribe();
        Map<String,Schema.SObjectField> allFlds = allObj.get(objName).getDescribe().fields.getMap();
        List<Schema.PicklistEntry> pickList = allFlds.get(fldName).getDescribe().getPickListValues();
        for(Schema.PicklistEntry pk : pickList){
            pkList.add(pk.getValue());
        }
        system.debug('ghj' +pkList);
        return pkList;
        
        
    }
    
    
}