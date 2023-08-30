public class TriggerOnMilestonesHelper {
    
    // This will add percentage level of project on its field through its milestones
    public static void updateProjectPrecentageLevel(List<Milestone__c> newMilestones) {
        Set<Id> projectsIDs = new Set<Id>();
        for (Milestone__c mls : newMilestones) {
            if (mls.Project__c != null) {
                projectsIDs.add(mls.Project__c);
            }
        }
        
        List<Project__c> projectsToBeSummedUp = [
            SELECT ID, Name, Percentage_Level__c, Project_End_Date__c, Account__c, Active__c, Type__c, Project_Start_Date__c,(SELECT ID, Name__c, Precentage__c FROM Milestones__r) FROM Project__c
            WHERE Id IN :projectsIDs];
        
        for (Project__c prj : projectsToBeSummedUp) {
            Decimal projectPrecentage = 0; // Moved this line outside the inner loop
            Integer numberOfMilestones = prj.Milestones__r.size();
            
            for (Milestone__c mls : prj.Milestones__r) {
                if (mls.Precentage__c != null) {
                    projectPrecentage += mls.Precentage__c;
                }
            }
            
            prj.Percentage_Level__c = projectPrecentage / numberOfMilestones;
        }
        
        update projectsToBeSummedUp; // Added this DML statement to update the changes back to the database
    }
}