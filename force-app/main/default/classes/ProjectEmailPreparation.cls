public class ProjectEmailPreparation {
    public static void sendEmailWithThreeColumnTable(List<Project__c> newProjects) {
        
        Set<Id> projecid = new Set<Id>();
        system.debug('newProjects==>'+newProjects);
        for(Project__c prj :newProjects ){
            projecid.add(prj.id);
        }
        String ProjectId='iciewncencec';
        String ProjectName='tututu';
        //Sample data to populate the table
        
        List<Milestone__c> MilestonesList= [SELECT id,Actual_End_Date__c,Expected_Start_Date__c,Expected_End_Date__c,Project__c,Actual_Start_Date__c,Name__c FROM Milestone__c WHERE Project__c IN :projecid];
        List<Project_Resource_Mapping__c> prmsList= [SELECT id,Type__c,Team_Member_Name__c,Name,Project_Name__c,Project__c,Contact__c,Card_Created__c FROM Project_Resource_Mapping__c WHERE Project__c IN :projecid ];
        system.debug('MilestonesList'+MilestonesList);
        system.debug('prmsList'+prmsList);
        List<String> Emailids = new List<String>();
        Set<Id> ContactsidSet = new Set<Id>();
        for(Project_Resource_Mapping__c prm :prmsList){
            ContactsidSet.add(prm.Contact__c);
        }
        
        system.debug('MilestonesList--'+MilestonesList);
        system.debug('prmsList--'+prmsList);
        
        List<Contact> Emailrecevers = [SELECT Id, Name, Email FROM Contact WHERE ID IN:ContactsidSet];
        for(Contact CON :Emailrecevers){
            Emailids.add(CON.Email);
        }
        //emailIds.add('kshubham.skr29@gmail.com');
        
        String introLines = 'Hello [Project Owner],\n\n'
            + 'I am delighted to inform you that we have successfully onboarded a new project!\n\n'
            + 'We have planned to implement it with the following timelines:\n\n';
        
        // Build the table
        String emailBody = '<html><body>' + introLines + '<table border="1">'
            + '<tr><th>Name</th><th>Expected Start Date</th><th>Expected End Date</th></tr>';
        
        for (Milestone__c ml : MilestonesList) {
            emailBody += '<tr>'
                + '<td>' + ml.Name__c + '</td>'
                + '<td>' + ml.Expected_Start_Date__c + '</td>'
                + '<td>' + ml.Expected_End_Date__c + '</td>'
                + '</tr>';
        }
        
        emailBody += '</table>';
        
        // Add the footer lines
        String footerLines = '\n\nAlso attaching the project tracker with this email so that we can easily ensure the Project timelines.\n\n'
            + 'Thank you,\n\n'
            + 'Ajeet\n'
            + 'CEO & Founder';
        
        emailBody += footerLines + '</body></html>';
        system.debug('Emailids--'+Emailids);
        system.debug('Emailrecevers--'+Emailrecevers);
        
        list<Messaging.SingleEmailMessage> EmailList = new  list<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        system.debug('Emailids'+Emailids);
        email.setToAddresses(Emailids);
        //email.set
        email.setSubject('New Project Onboarded'+ProjectName+'Implementation Timelines');
        email.setHtmlBody(emailBody);
        system.debug('email=================================>'+email);
        // Set the Letterhead ID for the email (replace '00NXXXXXXXXXXXXXXX' with the actual Letterhead ID)
        //email.setEntityLetterheadId('00NXXXXXXXXXXXXXXX'); // Replace with the actual Letterhead ID
        EmailList.add(email);
        // Send the email
        Messaging.sendEmail(EmailList);
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public static void sendSteeringMeetingData(List<Milestone__c> milestones) {
        map<id,List<Milestone__c>> milestonesbyProjectId = new  map<id,List<Milestone__c>>();
        
        Set<Id> milstonesID = new Set<Id>();
        for (Milestone__c mls : milestones) {
            if (mls.Name__c != null && mls.Name__c == 'Development') {
                milstonesID.add(mls.Id);
                //milestonesbyProjectId.add(mls.Project__c);
            }
            
        }
        
        //system.debug()
        
        List<Milestone__c> devmilestones = [SELECT Id, Actual_End_Date__c, Expected_Start_Date__c, Expected_End_Date__c, Project__c, Actual_Start_Date__c, Name__c,
                                            (SELECT Id, Name, Total_Utilised_Time__c, Total_Estimated_Effort__c, Stand_By_Resource__c, Project_Resource_Mapping__c, Project_Name__c, Project__c, Project__r.Name, Percentage_Level__c,
                                             Module_Start_Date__c, Module_End_Time__c, Module_Description__c, Module_Completed_Formula__c, Milestones_Name__c, Milestone__c, Is_Completed__c, Anticipated_Hours__c, Anticipated_End_Date__c,
                                             Actual_Estimated_Efforts__c
                                             FROM Modules__r)
                                            FROM Milestone__c
                                            WHERE Id IN :milstonesID];
        
        
        
        
        
        for (Milestone__c mls : devmilestones) {
            Date expectedDate = mls.Expected_Start_Date__c.addDays(-1);
            if(expectedDate == system.today() && mls.Name__c == 'Steering Committee Meeting'){
                if(milestonesbyProjectId.containsKey(mls.Project__c))
                    milestonesbyProjectId.get(mls.Project__c).add(mls);
                else
                    milestonesbyProjectId.put(mls.Project__c, new list<Milestone__c>{mls});
                
                
            }
            
            map<id,List<Module__c>> ModulebymilestonesId = new  map<id,List<Module__c>>();
            set<id> projectID = new set<id>();
            for(Id projId : milestonesbyProjectId.keySet()){
                List<Milestone__c> mlsList = milestonesbyProjectId.get(projId);
                for(Milestone__c mlss :mlsList){
                    Date expectedDatee = mls.Expected_Start_Date__c.addDays(-1);
                    if(mlss.Name__c=='Steering Committee Meeting' && expectedDatee==system.today()){
                        projectID.add(mlss.Project__c);
                        
                        
                    }
                    
                }
            }
            
            List<Module__c> ModuleList=[SELECT Id, Name, Total_Utilised_Time__c, Total_Estimated_Effort__c, Stand_By_Resource__c, Project_Resource_Mapping__c, Project_Name__c, Project__c, Project__r.Name, Percentage_Level__c,
                                        Module_Start_Date__c, Module_End_Time__c, Module_Description__c, Module_Completed_Formula__c, Milestones_Name__c, Milestone__c, Is_Completed__c, Anticipated_Hours__c, Anticipated_End_Date__c,
                                        Actual_Estimated_Efforts__c
                                        FROM Module__c WHERE Project__c IN:projectID AND Milestones_Name__c='Development'];
            
            String introLines = 'Hello [Project Owner],\n\n'
                + 'Through this email, we would like to apprise you on the status of!\n\n'
                + 'We have planned to implement it with the following timelines:\n\n'
                + 'Below Table will Show actual Status of Modules under development Stage/milestones till date You received :\n\n';
            
            String emailBody = '<html><body>' + introLines + '<table border="1">'
                + '<tr><th>Completed</th><th>Ongoing</th><th>Incomplete</th></tr>';
            
            for(Module__c mld:ModuleList){
                string compmdl='';
                string incmomdl='';
                string unchou='';
                emailBody += '<tr>'
                    + '<td>' + compmdl + '</td>'
                    + '<td>' + incmomdl + '</td>'
                    + '<td>' + unchou + '</td>'
                    + '</tr>';
                if (mld.Module_Start_Date__c == null) {
                    unchou +=mld.Name;
                } if (mld.Module_Start_Date__c != null && mld.Module_End_Time__c != null) {
                    incmomdl +=mld.Name;
                } else if (mld.Is_Completed__c == true) {
                    compmdl +=mld.Name;
                }
                
            }
          
         List<String> Emailids = new List<String>();
        Emailids.add('shubham.kumar@utilitarianlab.com');
        Emailids.add('chandan.k@utilitarianlab.com');
        Emailids.add('shiva.s@utilitarianlab.com');
        
        List<Messaging.SingleEmailMessage> EmailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(Emailids);
        email.setSubject('Steering Committee Report Inputs for ');
        //email.setHtmlBody(emailBody);
        EmailList.add(email);
        
        Messaging.sendEmail(EmailList);
            
            
        }
    }
    
}