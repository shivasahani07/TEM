public class ProjectList {
     @AuraEnabled 
    public static Map<Id,string> getProjectName(){
        list<Project__c> prolist = [Select id,Name From Project__c];
        Map<Id,string> mapProName = new Map<id,string>();
        for(Project__c pro : prolist){
            mapProName.put(pro.id,Pro.Name);
           
        }
        system.debug('All Project Name is ==>'+ mapProName);
        return mapProName;
    }
       @AuraEnabled 
    public static Map<Id,string> getTeamLead(){
        list<Contact> conlist = [Select id,Name,Role__c From Contact where Role__c = 'Team Lead' ];
        Map<Id,string> mapConTamLead = new Map<id,string>();
        for(Contact con : conlist){
            mapConTamLead.put(con.id,con.Name);
           
        }
        system.debug('All Project Name is ==>'+ mapConTamLead);
        return mapConTamLead;
    }
       @AuraEnabled 
    public static Map<Id,string> getAllRole(){
        list<Contact> conlist = [Select id,Name,Role__c From Contact  ];
        Map<Id,string> mapAllRole= new Map<id,string>();
        for(Contact con : conlist){
            mapAllRole.put(con.id,con.Name);
           
        }
        system.debug('All Project Name is ==>'+ mapAllRole);
        return mapAllRole;
    }
      @AuraEnabled 
    public static void createJiraTask(list<Jira_Task__c> taskRec){
        insert taskRec;
    }
    
       @AuraEnabled 
    public static map<Id,string> getModule(string projectid){
        list<Module__c> proModulelist =[Select Id ,Name,Project__c  From Module__c where Project__c=: projectid ]; 
        map<Id,string> mapProMod = new map<Id,string>();
        if(!proModulelist.isEmpty()){
        for(Module__c mod : proModulelist){
            mapProMod.put(mod.ID, mod.Name);
            }
        }
        System.debug('All Mdoule Relalted to projectId is ===>' +mapProMod);
    return mapProMod;

    }
}