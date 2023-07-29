public class AddModuleButtonHelper {
    @AuraEnabled
    Public Static List<DefaulModuleName__mdt> addModule(){
        List<DefaulModuleName__mdt> AutomateMpdulesList = new List<DefaulModuleName__mdt>();
        AutomateMpdulesList=[select id,DeveloperName,MasterLabel,Estimate_Time__c from DefaulModuleName__mdt];
        system.debug('AutomateMpdulesList::'+AutomateMpdulesList);
        return AutomateMpdulesList;
        
    }
    
    
    @AuraEnabled
    public static List<Module__c> saveModuleLIst(List<Module__c> mddList){
        system.debug('mddList -- ' + mddList);
        String projectId = mddList[0].project__c;
        system.debug('projectId -- ' + projectId);
        String DevMilestoneId = [Select id , Name__c from milestone__C where Name__c = 'Development' and project__c = :projectId limit 1].Id;
        system.debug('DevMilestoneId -- ' + DevMilestoneId);
        Map<ID, Milestone__c> milestoneRecById = new Map<ID, Milestone__c>([Select id , Name__c from Milestone__c where project__c = :projectId]);
        map<String,String> milestoneIdByName = new Map<String,String>(); 
        
        for(Milestone__c ms : milestoneRecById.values()){
            milestoneIdByName.put(ms.Name__c , ms.Id);
        }
        system.debug('milestoneIdByName===>>>>'+milestoneIdByName);
        
        for(Module__c mod : mddList){
            if( String.isNotBlank(mod.Project__c)){
                if(milestoneIdByName.ContainsKey(mod.Name)){
                    mod.Milestone__c = milestoneIdByName.get(mod.Name);
                }else{
                    mod.Milestone__c = DevMilestoneId;
                }
            }
        }
        system.debug('mddList last ::'+mddList);
        upsert mddList;
        return mddList;
    }
    
    @AuraEnabled
    Public Static  List<Module__c> allRelatedModule(String ProjectID ){
        system.debug('ProjectID::'+ProjectID);
        List<Module__c> createdModuleList =[select id,name,Milestone__c,Module_Description__c,Module_End_Time__c,Module_Start_Date__c,Actual_Estimated_Efforts__c,Total_Estimated_Effort__c from Module__c where Project__c =:ProjectID ];
        system.debug('createdModuleList::'+createdModuleList);
        return createdModuleList;
    }
    
    @AuraEnabled
    Public Static List<Milestone__c> getMilesstones(string projectiD){
        List<Milestone__c> MilestoneList=[select id,name,name__c,project__c,Closed_the_Milesstone__c,Actual_End_Date__c,Actual_Start_Date__c,Precentage__c,Description__c,Expected_Start_Date__c,Expected_End_Date__c,Account__c from Milestone__c  where project__c =:projectiD];
        return MilestoneList;
    }
    @AuraEnabled
    Public Static void UpdateMilesstones(List<Milestone__c> milstoneListTobeUpdate){
        system.debug('milstoneListTobeUpdate::'+milstoneListTobeUpdate);
        UPSERT milstoneListTobeUpdate;
        
    }
    
    @AuraEnabled
    Public Static   list<Module__c>  UpdateMilesstonesfromsite(String projID){
        String ProjectID=projID;
        system.debug('ProjectID::'+ProjectID);
        list<Module__c> ModuleList=[select id,name,Milestone__c,Module_Description__c,Module_End_Time__c,Module_Start_Date__c,Actual_Estimated_Efforts__c,Total_Estimated_Effort__c,Is_Completed__c,Anticipated_Hours__c,Project__c,Project_Resource_Mapping__c	 from Module__c where Project__c=:ProjectID];
        List<ModuleDataWrapper> dataToBeReturned = new List<ModuleDataWrapper>();
        for(Module__c mod : ModuleList){
            
        }
        system.debug('ModuleList::'+ModuleList);
        system.debug('dataToBeReturned'+dataToBeReturned);
        return ModuleList;
    }
    
    
    ///using in UpdateModuleForSite
    @AuraEnabled
    Public Static String UpdateModule(String Moduleid,String Action){
        String Actions=Action;
        if(Actions=='Delete'){
            Module__c Record =[select id,name from Module__c where id =:Moduleid];
            Delete Record;
        }else if(Actions=='Close'){
            Module__c Record =[select id,name,Is_Completed__c from Module__c where id =:Moduleid];
            if(Record.Is_Completed__c==false){
                Record.Is_Completed__c=True;
            }else if(Record.Is_Completed__c==true){
                Record.Is_Completed__c=false;
            }
            
            update Record;
        }
        
        return 'Success';
    }
     @AuraEnabled
    Public Static void UpdateModules(String Moduleid){
        Module__c Record =[select id,name from Module__c where id =:Moduleid];
        Delete Record;
    }
     @AuraEnabled
    Public Static void UpdateModuless(String Moduleid){
        Module__c Record =[select id,name,Is_Completed__c from Module__c where id =:Moduleid];
            if(Record.Is_Completed__c==false){
                Record.Is_Completed__c=True;
            }else if(Record.Is_Completed__c==true){
                Record.Is_Completed__c=false;
            }
            
            update Record;
    }
    
     @AuraEnabled
    Public Static void saveChangesRecordd(List<Module__c> ModuleList){
        system.debug('ModuleList::'+ModuleList);
        upsert ModuleList;
    }
    
    // qouery all project list for new custom lookup
    // 
       @AuraEnabled
    Public Static list<Project__c> getAllprojects(){
        list<Project__c> projects =[select id,name From Project__c ];
        return projects;
    }
    
   
}