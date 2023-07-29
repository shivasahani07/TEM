// created by Shiva using project milestones
// test class
public class TriggerOnProjectHelper {
    //creating defualt milestones using custom setting
    Public Static void createDefualtMileStoneCS(List<Project__c> ProjectList){
        List<Default_Milestone_project__c> defaultMilestones =[select id,Name,Description__c from Default_Milestone_project__c];
        system.debug('defaultMilestones::'+defaultMilestones);
        map<String,List<Project__c>>  MileStoneByProjectId = new map<String,List<Project__c>>();
        List<Milestone__c> milestoneList = new List<Milestone__c>();
        List<Project__c> proLIst = new List<Project__c>();
        for(Project__c pj: ProjectList){
            
            for(Default_Milestone_project__c dms :defaultMilestones){
                Milestone__c Mstone = new Milestone__c();
                Mstone.Name__c=dms.Name;
                Mstone.Project__c=pj.id;
                Mstone.Account__c=pj.Account__c;
                milestoneList.add(Mstone);
            }
            
        }
        if(!milestoneList.isEmpty()){
            insert milestoneList;
        }  
    }
    
}