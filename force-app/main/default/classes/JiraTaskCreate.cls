public class JiraTaskCreate {
    @AuraEnabled
    public static void createTask( Jira_Task__c taskRec){
        insert taskRec;
        system.debug('New Task Is===>>' +taskRec);
    }
     @AuraEnabled //get Account Industry Picklist Values
    public static Map<String, String> getPriority(){
        Map<String, String> options = new Map<String, String>();
        //get Account Industry Field Describe
        Schema.DescribeFieldResult fieldResult = Jira_Task__c.Priority__c.getDescribe();
        //get Account Industry Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled
    public static List<Jira_Task__c> displayJiraTask() {
        try{ 
            list<Jira_Task__c> tasklist =[SELECT Id,Description__c,Estimated_Efforts__c,Priority__c from Jira_Task__c ];
        return tasklist;
        }catch(exception e){
            system.debug('Error Message ' + e.getMessage() +'Error line :' +e.getLineNumber());
        }
        return null;
    }

}