public class ProjectDashbordHelper {
	@auraEnabled
    Public Static List<Project__c> activeProjcts(){
        List<Project__c> ActiveProjectsList=[select id,name,Active__c,Account__r.Name,Project_End_Date__c,Project_Start_Date__c,Type__c from Project__c where Active__c = true];
        system.debug('ActiveProjectsList::'+ActiveProjectsList);
        return ActiveProjectsList;
    }
    
    @auraEnabled
    Public Static List<Project__c> InactiveProjcts(){
        List<Project__c> InActiveProjectsList=[select id,name,Active__c,Account__r.Name,Project_End_Date__c,Project_Start_Date__c,Type__c from Project__c where Active__c = false];
        system.debug('InActiveProjectsList::'+InActiveProjectsList);
        return InActiveProjectsList;
    }
}