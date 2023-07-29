public class TriggerOnModuleHelper {
    // this method will update module when first tastk will be created for milestone  actual start date
    
    Public Static void updateMilesStones(List<Module__c> newList){
        map<String,Module__c> moduleByJiraTask = new map<String,Module__c>();
        List<String> MilestonesId  = new List<String>();
        
        for(Module__c mdl :newList){
            if(mdl.Milestone__c != null){
                MilestonesId.add(mdl.Milestone__c);
            }
        }
        Map<ID, Milestone__c> milesStoneBymilesStoneID = new Map<ID, Milestone__c>([SELECT Account__c,Actual_End_Date__c,Actual_Start_Date__c,Anticipated_End_Date__c,Closed_the_Milesstone__c,
                                                                                    Description__c,Expected_End_Date__c,Expected_Start_Date__c,Id,Milestone_Weightage_Rs__c,Milestone_Weightage__c,
                                                                                    Name,Name__c,Project__c,RecordTypeId,Tentative_Date_of_Payment__c,Total_Utilised_Time__c FROM Milestone__c Where ID IN :MilestonesId]);
        
        for(Module__c mdl :newList){
            if(mdl.Milestone__c != null && mdl.Total_Utilised_Time__c != null && milesStoneBymilesStoneID.get(mdl.Milestone__c).Total_Utilised_Time__c != Null){
                system.debug('mdl.Milestone__c'+milesStoneBymilesStoneID.get(mdl.Milestone__c));//.Total_Utilised_Time__c);
                milesStoneBymilesStoneID.get(mdl.Milestone__c).Total_Utilised_Time__c = milesStoneBymilesStoneID.get(mdl.Milestone__c).Total_Utilised_Time__c + mdl.Total_Utilised_Time__c;
                milesStoneBymilesStoneID.get(mdl.Milestone__c).Actual_Start_Date__c = milesStoneBymilesStoneID.get(mdl.Milestone__c).Actual_Start_Date__c < mdl.Module_Start_Date__c ?  milesStoneBymilesStoneID.get(mdl.Milestone__c).Actual_Start_Date__c :mdl.Module_Start_Date__c;
                
                
                
            }
            else{
                milesStoneBymilesStoneID.get(mdl.Milestone__c).Total_Utilised_Time__c = mdl.Total_Utilised_Time__c;
                milesStoneBymilesStoneID.get(mdl.Milestone__c).Actual_Start_Date__c = milesStoneBymilesStoneID.get(mdl.Milestone__c).Actual_Start_Date__c < mdl.Module_Start_Date__c ?  milesStoneBymilesStoneID.get(mdl.Milestone__c).Actual_Start_Date__c :mdl.Module_Start_Date__c;
                
            }
        }
        if(!milesStoneBymilesStoneID.isEmpty()){
            update milesStoneBymilesStoneID.values();
        }
    }
    //THIS METHOD WILL UPDATE MILESTONE PERCENTAGE LEVEL ON = (CLOED MODULE/TOTAL MODULE)*100 F
    Public Static void updateMilstonepercentage(List<Module__c> newList){
        system.debug('newList::'+newList);
        list<String> milstonesidList = new  list<String>();
        for(Module__c md:newList){
            if(md.Milestone__c !=null){
                milstonesidList.add(md.Milestone__c);
            }
        }
        system.debug('milstonesidList::'+milstonesidList);
        Map<Id,Milestone__c> mileStoneMap = new Map<Id,Milestone__c>([Select Id, Precentage__c,(Select Id, Is_Completed__c From Modules__r) from Milestone__c where Id In : milstonesidList]);
        for(Milestone__c ms : mileStoneMap.values()){
            integer totalModules = ms.Modules__r.size();
            integer totalCheckboxTrue = 0;
            system.debug('totalModules::'+totalModules);
            
            
            for(Module__c mod : ms.Modules__r){
                if(mod.Is_Completed__c){
                    totalCheckboxTrue++;
                    //totalCheckboxTrue=totalCheckboxTrue+1;
                    system.debug('totalCheckboxTrue::'+totalCheckboxTrue);
                }
            }
            
            Decimal percentage = (totalCheckboxTrue/totalModules)*100;
            system.debug('percentage::'+percentage);
            ms.Precentage__c = percentage; 
        }
        
        
        system.debug('milstonesidList::'+milstonesidList);
        system.debug('mileStoneMap::'+mileStoneMap);
        update mileStoneMap.values();
    }
    //////////////////////////////////
    Public Static void testupdateModule(List<Module__c> newList){
        List<Id> milestoneIds = new List<Id>();
        Map<Id, Decimal> milestoneCompletionMap = new Map<Id, Decimal>();
        
        // Collect milestone IDs from input Module__c records
        for (Module__c module :newList) {
            milestoneIds.add(module.Milestone__c);
        }
        
        // Retrieve relevant milestones and their child modules
        List<Milestone__c> milestones = [SELECT Id, (SELECT Id, Is_Completed__c FROM Modules__r) FROM Milestone__c WHERE Id IN :milestoneIds];
        
        // Calculate completion percentage for each milestone based on child module completion status
        for (Milestone__c milestone : milestones) {
            List<Module__c> modules = milestone.Modules__r;
            Decimal completedCount = 0;
            
            for (Module__c module : modules) {
                if (module.Is_Completed__c) {
                    completedCount++;
                }
            }
            
            Decimal completionPercentage = (completedCount / modules.size()) * 100;
            milestoneCompletionMap.put(milestone.Id, completionPercentage);
        }
        
        // Update milestone completion percentages
        List<Milestone__c> milestonesToUpdate = new List<Milestone__c>();
        
        for (Id milestoneId : milestoneCompletionMap.keySet()) {
            Milestone__c milestone = new Milestone__c(Id=milestoneId, Precentage__c=milestoneCompletionMap.get(milestoneId));
            milestonesToUpdate.add(milestone);
        }
        
        update milestonesToUpdate;
        
    }
    
    //////////////////////////////////
    Public Static void twotestupdateModule(List<Module__c> newList){
        List<Id> milestoneIds = new List<Id>();
        Map<Id, Decimal> milestoneCompletionMap = new Map<Id, Decimal>();
        
        // Collect milestone IDs from input Module__c records
        for (Module__c module :newList) {
            milestoneIds.add(module.Milestone__c);
        }
        
        // Retrieve relevant milestones and their child modules
        List<Milestone__c> milestones = [SELECT Id, (SELECT Id, Is_Completed__c,Percentage_Level__c,Anticipated_Hours__c,Module_Completed_Formula__c FROM Modules__r) FROM Milestone__c WHERE Id IN :milestoneIds];
        
        // Calculate completion percentage for each milestone based on child module completion status
        for (Milestone__c milestone : milestones) {
            List<Module__c> modules = milestone.Modules__r;
            Decimal completedCount = 0;
            Decimal totalPercentage = 0;
            
            for (Module__c module : modules) {
                if(module.Module_Completed_Formula__c !=null){
                    totalPercentage += module.Module_Completed_Formula__c;
                }
                
                
            }
            
            completedCount=modules.size();
            Decimal completionPercentage = (totalPercentage /completedCount);
            milestoneCompletionMap.put(milestone.Id, completionPercentage);
            system.debug('totalPercentage::'+totalPercentage);
            system.debug('completedCount::'+completedCount);
            system.debug('completionPercentage::'+completionPercentage);
            
        }
        
        // Update milestone completion percentages
        List<Milestone__c> milestonesToUpdate = new List<Milestone__c>();
        
        for (Id milestoneId : milestoneCompletionMap.keySet()) {
            Milestone__c milestone = new Milestone__c(Id=milestoneId, Precentage__c=milestoneCompletionMap.get(milestoneId));
            milestonesToUpdate.add(milestone);
        }
        
        update milestonesToUpdate;
        
    }
    
    
}