global  without sharing class EmailTriggerHelperClass {
    Public Static void mailOnTaskGeneration(List<Jira_Task__c> jtlist){
        system.debug('jtlist'+jtlist);
        //Creating map of email Templates
        map<String,EmailTemplate> emailTemplatesByName = new map<String,EmailTemplate>();
        map<id,Contact> ContactDetailsById = new map<id,Contact>();
        map<Id , Jira_Task__c> jiraTaskDetailsByConId = new map<Id , Jira_Task__c>();
        EmailTemplate[] allEmailTemplates = [SELECT Id, Subject, HtmlValue,Name,Body FROM EmailTemplate];
        for(EmailTemplate et : allEmailTemplates){
            emailTemplatesByName.put(et.Name , et);
        }
        List<id> conIdsForTaskCreation = new List<id> ();
        List<id> conIdsForTaskCompletion = new List<id> ();
        List<id> conIdsForTaskExtension = new List<id> ();
        //List<id> conIdsForDependencyCreation = new List<id> ();
        
        for(Jira_Task__c jt :jtlist){
            if(jt.Team_Member__c != null && jt.Status__c == 'New' &&  jt.Task_Start_Date_Time__c == null  ){
                conIdsForTaskCreation.add( jt.Team_Member__c);
                jiraTaskDetailsByConId.put(jt.Team_Member__c,jt);
            }
            
            if(jt.Team_Member__c != null && jt.Status__c == 'Dev Completed' &&  jt.Task_Start_Date_Time__c != null && jt.Task_End_Date_Time__c != null){
                conIdsForTaskCompletion.add(jt.Assigned_By__c);
                jiraTaskDetailsByConId.put(jt.Assigned_By__c,jt);
            }
            
            if(jt.Team_Member__c != null && jt.Extension_Reason__c != null &&  jt.Task_Start_Date_Time__c != null ){
                conIdsForTaskExtension.add(jt.Team_Member__c);
                jiraTaskDetailsByConId.put(jt.Team_Member__c,jt);
            }
        }
        system.debug('conIdsForTaskCreation'+conIdsForTaskCreation);
        system.debug('conIdsForTaskCompletion'+conIdsForTaskCompletion);
        system.debug('conIdsForTaskExtension'+conIdsForTaskExtension);
        List<contact> conListTaskCreation =[select id,name,email from contact  where id In :conIdsForTaskCreation];
        List<contact> conListTaskCompletion =[select id,name,email from contact  where id In :conIdsForTaskCompletion];
        List<contact> conListTaskExtension =[select id,name,email from contact  where id In :conIdsForTaskExtension];
        
        //Task Creation Email template
        List<Messaging.SingleEmailMessage>  sendEmails = new List<Messaging.SingleEmailMessage>();
        for (Contact con: conListTaskCreation) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Task assinged');
            email.setTemplateId(emailTemplatesByName.get('Task Creation Template').Id);
            email.setTargetObjectId(con.Id);
            String Body = emailTemplatesByName.get('Task Creation Template').HtmlValue;
            Body = Body.replace('{!Jira_Task__c.Team_Member_Name__c}',jiraTaskDetailsByConId.get(con.Id).Team_Member_Name__c );
            Body = Body.replace('{!Jira_Task__c.Name}',jiraTaskDetailsByConId.get(con.Id).Name );
            Body = Body.replace('{!Jira_Task__c.Estimated_Start_Date__c}',String.valueOf(jiraTaskDetailsByConId.get(con.Id).Estimated_Start_Date__c));
            Body = Body.replace('{!Jira_Task__c.Estimated_Efforts__c}',String.valueOf(jiraTaskDetailsByConId.get(con.Id).Estimated_Efforts__c));
            Body = Body.replace('{!Jira_Task__c.Assigned_By_Name__c}',jiraTaskDetailsByConId.get(con.Id).Assigned_By_Name__c);
            Body = Body.replace('{!Jira_Task__c.Priority__c}',jiraTaskDetailsByConId.get(con.Id).Priority__c);
            email.setHtmlBody(Body);
            email.setSenderDisplayName('Ajeet Kumar');
            system.debug(emailTemplatesByName.get('Task Creation Template').HtmlValue);
            email.saveAsActivity = false;
            email.toAddresses = new String[] { con.email,'chandan.k@utilitarianLab.com'};
            sendEmails.add(email);
        }
       
        //Task Completion Email template
        for (Contact con: conListTaskCompletion) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Task Completed.');
            email.setTemplateId(emailTemplatesByName.get('Task Completion Template').Id);
            email.setTargetObjectId(con.Id);
            String Body = emailTemplatesByName.get('Task Completion Template').HtmlValue;
            Body = Body.replace('{!Jira_Task__c.Team_Member_Name__c}',jiraTaskDetailsByConId.get(con.Id).Team_Member_Name__c );
            Body = Body.replace('{!Jira_Task__c.Name}',jiraTaskDetailsByConId.get(con.Id).Name );
            Body = Body.replace('{!Jira_Task__c.Estimated_Start_Date__c}',String.valueOf(jiraTaskDetailsByConId.get(con.Id).Estimated_Start_Date__c));
            Body = Body.replace('{!Jira_Task__c.Estimated_Efforts__c}',String.valueOf(jiraTaskDetailsByConId.get(con.Id).Estimated_Efforts__c));
            Body = Body.replace('{!Jira_Task__c.Assigned_By_Name__c}',jiraTaskDetailsByConId.get(con.Id).Assigned_By_Name__c);
            Body = Body.replace('{!Jira_Task__c.Total_Utilised_Time__c}',String.valueOf(jiraTaskDetailsByConId.get(con.Id).Total_Utilised_Time__c));
            Body = Body.replace('{!Jira_Task__c.Priority__c}',jiraTaskDetailsByConId.get(con.Id).Priority__c);
            email.setHtmlBody(Body);
            email.setSenderDisplayName('Ajeet Kumar');
            
            email.saveAsActivity = false;
            email.toAddresses = new String[] { con.email,'chandan.k@utilitarianLab.com'};
            sendEmails.add(email);
        }
        
        //Task Extesnion Email template
      
        for (Contact con: conListTaskExtension) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Task assinged');
            email.setTemplateId(emailTemplatesByName.get('Task Extension Template').Id);
            email.setTargetObjectId(con.Id);
            String Body = emailTemplatesByName.get('Task Extension Template').HtmlValue;
            Body = Body.replace('{!Jira_Task__c.Team_Member_Name__c}',jiraTaskDetailsByConId.get(con.Id).Team_Member_Name__c );
            Body = Body.replace('{!Jira_Task__c.Name}',jiraTaskDetailsByConId.get(con.Id).Name );
            Body = Body.replace('{!Jira_Task__c.Estimated_Start_Date__c}',String.valueOf(jiraTaskDetailsByConId.get(con.Id).Estimated_Start_Date__c));
            Body = Body.replace('{!Jira_Task__c.Estimated_Efforts__c}',String.valueOf(jiraTaskDetailsByConId.get(con.Id).Estimated_Efforts__c));
            Body = Body.replace('{!Jira_Task__c.Assigned_By_Name__c}',jiraTaskDetailsByConId.get(con.Id).Assigned_By_Name__c);
            Body = Body.replace('{!Jira_Task__c.Extension_Reason__c}',jiraTaskDetailsByConId.get(con.Id).Extension_Reason__c);
            email.setHtmlBody(Body);
            email.setSenderDisplayName('Ajeet Kumar');
            system.debug(emailTemplatesByName.get('Task Extension Template').HtmlValue);
            email.saveAsActivity = false;
            email.toAddresses = new String[] { con.email,'chandan.k@utilitarianLab.com'};
            sendEmails.add(email);
        }
        system.debug('sendEmails'+sendEmails);
        Messaging.sendEmail(sendEmails);
    }
}