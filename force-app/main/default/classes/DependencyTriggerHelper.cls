public class DependencyTriggerHelper {
    //String taskCompleted = templateforTaskcompletion[0].HtmlValue;
    Public Static void onDependencyCreation(List<Dependency__c> depncyList){
        List<id> depeConListId = new  List<id>();
        system.debug('depeConListId---'+depeConListId);
        for(Dependency__c dp :depncyList ){
            if(dp.Depends_on__c != null && dp.Jira_Task__c != null && dp.Description__c != null){
                depeConListId.add(dp.Depends_on__c);
                system.debug('Hii im inside the for to check it ');
            }
        }
        List<contact> depeConList =[SELECT id,name ,email from contact where id In :depeConListId ];
        system.debug('depeConList---'+depeConList);
        EmailTemplate[] emtelFordepenCreated = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'Dependency_Created'];
        List<String> dependentCtraed = new List<String>();
        for(EmailTemplate eT :emtelFordepenCreated ){
            dependentCtraed.add(eT.Body);
            
        }
        for (Contact con: depeConList) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Depency is Created On You!!');
            //email.setTemplateId(emailTemplate[0].id);
            email.setTargetObjectId(con.Id);
            //email.setWhatId(jiraId);
           // email.setHtmlBody(emailTemplate[0].HtmlValue);
            email.saveAsActivity = false;
            // email.setTemplateID(emailTemplate[0].id);
            //email.setWhatId(con.Id);
           // email.toAddresses = new String[] { con.email,conpm.email};
               // sendEmails.add(email);
        }
        
        
        
        
        
        
        
        
        
    }
}