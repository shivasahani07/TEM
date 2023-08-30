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
        
        createDefaultPrm(ProjectList);
        
        
    }
    
    
    // whenever a project is onboarded there will be 5 prms for ajeet,chandan,sara,prthivi
    
    Public Static void createDefaultPrm(list<Project__c> newProjects){
        system.debug('newProjects--'+newProjects);
        List<Project_Resource_Mapping__c> PrmsToBeInserted = new List<Project_Resource_Mapping__c>();
        for(Project__c pro :newProjects){
            List<Defaultprms__mdt> mcs = Defaultprms__mdt.getAll().values();
            boolean textField = null;
            for(Defaultprms__mdt dprm :mcs){
                Project_Resource_Mapping__c defaultPrms = new Project_Resource_Mapping__c();
                defaultPrms.Contact__c=dprm.Contact_id__c;
                defaultPrms.Type__c=dprm.Contact_role__c;
                defaultPrms.Project__c=pro.id;
                PrmsToBeInserted.add(defaultPrms); 
            }
            
            if(!PrmsToBeInserted.isEmpty()){
                insert PrmsToBeInserted;
                ProjectEmailPreparation.sendEmailWithThreeColumnTable(newProjects);
            }
        }
    }
    //-------------------------------------------------------------------------
    //
    
    public static void sendEmailWithMergeFields(List<Project__c> newProjects) {
        // Step 1: Query the related objects and store the data in variables
        // Assuming you have two related objects: ObjectA and ObjectB
        
        String ProjectId='iciewncencec';
        List<Milestone__c> MilestonesList= [SELECT id,Actual_End_Date__c,Expected_Start_Date__c,Expected_End_Date__c,Project__c,Actual_Start_Date__c FROM Milestone__c WHERE Project__c =: ProjectId];
        List<Project_Resource_Mapping__c> prmsList= [SELECT id,Type__c,Team_Member_Name__c,Name,Project_Name__c,Project__c,Contact__c,Card_Created__c FROM Project_Resource_Mapping__c WHERE Project__c =:ProjectId AND (Type__c = 'CEO' AND Type__c = 'Lead' and Type__c= 'Project Manager' and Type__c='Consultant') ];
        
        // Related_ObjectB__r is the relationship name from ObjectA to ObjectB.
        string emailBody ='bjbjbjb';
        // Step 2: Build the email body using the merge fields from the related objects
        /* String emailBody = 'Hello, ' + objA.Name + '\n\n'
+ 'Here are some details from ObjectA:\n'
+ 'FieldA: ' + objA.FieldA__c + '\n\n'
+ 'Details from Related ObjectB:\n'
+ 'ObjectB Name: ' + objA.Related_ObjectB__r.Name + '\n'
+ 'FieldB: ' + objA.Related_ObjectB__r.FieldB__c + '\n';  
*/
        
        // Step 3: Send the email using the Apex Messaging classes
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'recipient@example.com'}; // Replace with the actual recipient's email address
            email.setToAddresses(toAddresses);
        email.setSubject('Sample Email with Merge Fields');
        email.setPlainTextBody(emailBody);
        
        // Optionally, you can add more recipients, CC, BCC, or set the email as HTML
        // email.setCcAddresses(new String[]{'cc@example.com'});
        // email.setBccAddresses(new String[]{'bcc@example.com'});
        // email.setHtmlBody(emailBody);
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
    //========================================================================
    public static void sendEmailWithThreeColumnTable(List<Project__c> newProjects) {
        
        Set<Id> projecid = new Set<Id>();
        
        for(Project__c prj :newProjects ){
           projecid.add(prj.id);
        }
        String ProjectId='iciewncencec';
        String ProjectName='tututu';
        // Sample data to populate the table
        List<Contact> contacts = [SELECT Id, Name, Email FROM Contact LIMIT 5];
        List<Milestone__c> MilestonesList= [SELECT id,Actual_End_Date__c,Expected_Start_Date__c,Expected_End_Date__c,Project__c,Actual_Start_Date__c,Name__c FROM Milestone__c WHERE Project__c =: projecid];
        List<Project_Resource_Mapping__c> prmsList= [SELECT id,Type__c,Team_Member_Name__c,Name,Project_Name__c,Project__c,Contact__c,Card_Created__c FROM Project_Resource_Mapping__c WHERE Project__c =:projecid AND (Type__c = 'CEO' AND Type__c = 'Lead' and Type__c= 'Project Manager' and Type__c='Consultant') ];
        List<String> Emailids = new List<String>();
        Set<Id> ContactsidSet = new Set<Id>();
        for(Project_Resource_Mapping__c prm :prmsList){
            ContactsidSet.add(prm.Contact__c);
        }
        
        
        List<Contact> Emailrecevers = [SELECT Id, Name, Email FROM Contact WHERE ID IN:ContactsidSet];
        for(Contact CON :Emailrecevers){
            Emailids.add(CON.Email);
        }
        
        String introLines = 'Hello [Project Owner],\n\n'
            + 'I am delighted to inform you that we have successfully onboarded a new project!\n\n'
            + 'We have planned to implement it with the following timelines:\n\n';
        String  footerLines = 'Also attaching the project tracker with this email so that we can easily ensure the Project timelines.\n\n'
            + 'Thank you,\n\n'
            + 'Ajeet\n'
            + 'CEO & Founder';
        
        
        // Build the table
        String emailBody = '<html><body>' + introLines + '<table border="1">'
            + '<tr><th>Name</th><th>Expected Start Date</th><th>Expected End Date</th></tr>'+footerLines;
        
        for (Milestone__c ml : MilestonesList) {
            emailBody += '<tr>'
                + '<td>' + ml.Name__c + '</td>'
                + '<td>' + ml.Expected_Start_Date__c + '</td>'
                + '<td>' + ml.Expected_End_Date__c+ '</td>'
                + '</tr>';
        }
        emailBody += '</table></body></html>';
        
        
        
        // Send the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[]{'recipient@example.com'}; // Replace with the actual recipient's email address
        email.setToAddresses(Emailids);
        email.setSubject('New Project Onboarded'+ProjectName+'Implementation Timelines');
        // Set the email body as HTML content
        // Set the Letterhead ID for the email (replace '00NXXXXXXXXXXXXXXX' with the actual Letterhead ID)
        // email.setEmailTemplateId('2F0162v000000scnP');
        // email.setEntityLetterheadId('');
        // Attach the project tracker to the email
        //email.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
        // Send the email
        email.setHtmlBody(emailBody);
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
    
}