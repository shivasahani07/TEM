global class Generate_Invoice_Project_Controller {
    
    
    public String currentRecordId {get; set;}
    public String accId {get; set;}
    public Account accountDetails {get; set;}
    public Invoice_details__c invDetails {get; set;}
    public List<Project_Resource_Mapping__c> PRMDetails {get; set;}
    global List<projectMappingWrapper> wrapperList {get; set;}
    global decimal totalvalue {get; set;}
    global decimal CGSTvalue {get; set;}
    global decimal SGSTvalue {get; set;}
    global decimal finalAmount {get; set;}
    public string currencyType {get;set;}
    public Date generationDate {get;set;}
    global Generate_Invoice_Project_Controller(){
        
        currentRecordId =  ApexPages.CurrentPage().getparameters().get('id');
        system.debug('currentRecordId===>'+currentRecordId);
        project__c prmRecord=[select Name,id,Account__c from project__c where id =:currentRecordId][0];
        accId = prmRecord.Account__c;
        
        accountDetails = [select name,Banglore_GSTIN_applicable__c,Place_of_Supply__c,id,Tax_Invoice__c,Shipping_Address__c,BillingStreet, BillingCity, BillingState,Phone,Client_Currency__c, BillingPostalCode,BillingCountry,website,Per_Hour_Rate__c,Is_Foreign_Client__c,GSTIN__c,(select name,Shipping_Address__c,CGST__c,SGST__c,id,Description__c,Start_Date__c,End_Date__c,Resource_Name__c  ,Hours__c,Genration_Date__c,Due_Date__c,Balance_Due__c,Discount__c,GST__c,Other_Charges__c,Total__c,Total_Tax__c,Sub_Total__c,Sub_Total_Less_Discount__c,is_Hours_Applicable__c,Project_Cost__c from invoices__r ORDER BY lastmodifieddate DESC limit 1) from Account where id=:accId];
        if(accountDetails.invoices__r[0].Genration_Date__c != null){
            generationDate = accountDetails.invoices__r[0].Genration_Date__c;
        }
        else if(accountDetails.invoices__r[0].Genration_Date__c == null){
            Date invoiceGenerationDate =  accountDetails.invoices__r[0].Start_Date__c;
            Integer month = invoiceGenerationDate.Month();
            if(month<12){
                month = month + 1;
                String stringMonthval = String.valueOf(month);
                Integer year = invoiceGenerationDate.Year();
                String stringYear =  String.valueOf(year);
                String startingDate  = '1';
                generationDate = date.parse(stringMonthval+'/'+startingDate+'/'+stringYear);
            }
            else if(month == 12){
                Date invoiceGeneratedDate =  accountDetails.invoices__r[0].Start_Date__c;
                month = 1;
                String stringMonthval = String.valueOf(month);
                Integer year = invoiceGeneratedDate.Year();
                year = year + 1;
                String stringYear =  String.valueOf(year);
                String startingDate  = '1';
                generationDate = date.parse(stringMonthval+'/'+startingDate+'/'+stringYear);//
            }
        }
        
        
        
        if(accountDetails.Is_Foreign_Client__c == true){
            currencyType = '$';
        }
        else if(accountDetails.Is_Foreign_Client__c == false){
            currencyType = 'INR';
        }
        system.debug('accountDetails==>'+accountDetails);
        //custom setting
        invDetails = [select name,Bank_Name__c,Company_Name__c,SAC_Code__c,Faridabad_GST_Reg_no__c,Account_Number__c,Bank_IFSC_Code__c,Company_PAN__c,Company_TAN__c,GST_Reg_No__c,Address__c,Phone__c,Bank_Swift_Code__c from Invoice_details__c where name ='UTILLABS'];
        system.debug('invDetails==>'+invDetails);
		List<projectMappingWrapper> wrapperListData = new  List<projectMappingWrapper> ();
        PRMDetails  = [SELECT Contact__r.Name,Type__c,Project__r.Resource_Price_Rate__c,(Select id , Total_Efforts__c From Time_Entry_Monthly_Card__r) FROM Project_Resource_Mapping__c where project__C = 'a1L6D000001XhDKUA0'];
        decimal totalBalance = 0;
        
        for(Project_Resource_Mapping__c prm : PRMDetails){
            for(Time_Entry_Monthly_Card__c tem : prm.Time_Entry_Monthly_Card__r){
               
                system.debug('tem.Total_Efforts__c'+prm.Project__r.Resource_Price_Rate__c);
                if(tem.Total_Efforts__c > 0){
                    projectMappingWrapper pmw = new projectMappingWrapper(prm.Contact__r.Name,prm.Type__c,tem.Total_Efforts__c,prm.Project__r.Resource_Price_Rate__c,(tem.Total_Efforts__c * prm.Project__r.Resource_Price_Rate__c));
                    system.debug('--------pmw--->>'+pmw);
                    totalBalance = totalBalance + tem.Total_Efforts__c * prm.Project__r.Resource_Price_Rate__c;
                    wrapperListData.add(pmw);
                    wrapperList = wrapperListData;
                }
            }
        }
        totalvalue = totalBalance;
        CGSTvalue = 0.09*totalBalance.setScale(2);
        CGSTvalue = CGSTvalue.setScale(2);
        SGSTvalue = 0.09*totalBalance.setScale(2);
        SGSTvalue = SGSTvalue.setScale(2);
        finalAmount = totalBalance+CGSTvalue+SGSTvalue;
       
    }
    
    
    @AuraEnabled
    global static String attachPDF(string accId) {
        system.debug('accId'+accId);
        project__c prmRecord=[select Name,id from project__c where id =:accId][0];
        
        //generate and attach the PDF document
        PageReference pdfPage = Page.Generate_Invoice_Project; //create a page reference to our pdfDemo Visualforce page, which was created from the post https://interactiveties.com/blog/2015/render-visualforce-pdf.php
        pdfPage.getParameters().put('id',accId);
        
        Blob pdfBlob; //create a blob for the PDF content
        pdfBlob = pdfPage.getContent(); //generate the pdf blob
        
        Date strtDate = system.today();
        Integer monthIntVal = strtDate.Month(); //get month integer value
        string monthStrVal = convertNumberToMonth(monthIntVal);         
        if(monthStrVal == ''&& monthStrVal == null) monthStrVal = 'Invoice';
        Attachment attach = new Attachment(parentId = accId, Name = 'UtilitarianLab-'+prmRecord.Name+'-Invoice-'+monthStrVal+'.pdf', body = pdfBlob); //create the attachment object
        insert attach;
        system.debug(attach.Id);
        /*List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        List<Account> customerRecord = [SELECT Email__c,First_Name__c,Last_Name__c,Name FROM Account WHERE Id =: accId AND Email__c != null];
        system.debug(customerRecord);
        
        Invoice__c invDetails = [select name,Due_Date__c from Invoice__c where Account__r.id =:accId  ORDER BY CreatedDate DESC NULLS LAST limit 1];
        
        EmailTemplate et=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = 'Send Bulk Invoices To CA' limit 1];
        Attachment files = [SELECT Name, Body, ContentType FROM Attachment WHERE ParentId =:accId ORDER BY CreatedDate DESC NULLS LAST limit 1 ];
        
        //custom setting
        CA_Info__c CA_Info_Rec = [Select Email__c,First_Name__c,Last_Name__c From CA_Info__c];
        
        
        system.debug('mails'+mails);
        if(CA_Info_Rec != null){
            List<String> recipients = new List<String>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            
            efa.setFileName(files.Name);
            efa.setBody(files.Body);
            efa.setContentType(files.ContentType);
            
            recipients.add(CA_Info_Rec.Email__c);
            mail.setToAddresses(recipients);
            mail.setReplyTo('chandan.k@utilitarianlab.com');
            mail.setSenderDisplayName('Utilitarian Lab');
            
            String htmlBody = et.HtmlValue;
            htmlBody = htmlBody.replace('{!CA.FirstName}', CA_Info_Rec.First_Name__c != null? CA_Info_Rec.First_Name__c : '');
            htmlBody = htmlBody.replace('{!CA.LastName}', CA_Info_Rec.Last_Name__c != null? CA_Info_Rec.Last_Name__c:'');
            htmlBody = htmlBody.replace('{!Account.Name}', customerRecord[0].Name != null ? customerRecord[0].Name :'' );       
            mail.setHtmlBody(htmlBody);
            
            String subject = et.Subject;
            mail.setSubject(subject);
            
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
            mails.add(mail);
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);
            } 
        }   */
        //return pageWhereWeWantToGo; //send the User on their way  
        return 'Success';
    }
    
    webservice static String attachPDFClassic(string accId) {
        Account accRecord=[select name,id from account where id =:accId];
        //generate and attach the PDF document
        PageReference pdfPage = Page.Generate_Invoice; //create a page reference to our pdfDemo Visualforce page, which was created from the post https://interactiveties.com/blog/2015/render-visualforce-pdf.php
        pdfPage.getParameters().put('id',accRecord.Id);
        
        Blob pdfBlob; //create a blob for the PDF content
        //otherwise, we are in testing context and getContent() gets funky so create the blob manually
        //pdfBlob = Blob.valueOf('Some Text for a boring PDF file...');
        pdfBlob = pdfPage.getContent();
        
        Attachment attach = new Attachment(parentId = accRecord.Id, Name = 'pdfAttachmentDemo.pdf', body = pdfBlob); //create the attachment object
        insert attach;
        //return pageWhereWeWantToGo; //send the User on their way  
        return 'Success';
    }
    @AuraEnabled
    global static void sendEmail(string accId) {
        try{
            list<Contact> conRecords = [select name,id,Email,Contact_Role__c,FirstName from Contact where AccountId =:accId AND Contact_Role__c = 'Finance'];
            system.debug(conRecords);
            Invoice__c invDetails = [select name,Due_Date__c from Invoice__c where Account__r.id =:accId ORDER BY lastmodifieddate DESC limit 1];
            system.debug(invDetails);
            EmailTemplate et=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = 'send Invoice' limit 1];
            Attachment files = [SELECT Name, Body, ContentType FROM Attachment WHERE ParentId =:accId ORDER BY lastmodifieddate DESC limit 1 ];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            system.debug('mails'+mails);
            for (Contact ct : conRecords) {
                // Step 1
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(files.Name);
                efa.setBody(files.Body);
                efa.setContentType(files.ContentType);
                
                // Step 2: Set list of recipients who will get the email
                List<String> recipients = new List<String>();
                
                recipients.add(ct.Email);
                system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                
                //Step 3: Set sender information
                mail.setReplyTo('test@email.com');
                mail.setSenderDisplayName('Test Organization');
                
                // Step 4. Generate Content!
                
                //String body = et.Body;
                String subject = et.Subject;
                system.debug('subject'+subject);
                //subject = subject.replace('{!Contact.FirstName}', ct.FirstName);
                String htmlBody = et.HtmlValue;
                system.debug('htmlBody'+htmlBody);
                system.debug('Contact'+ct);
                system.debug('ct.FirstName'+ct.FirstName);
                htmlBody = htmlBody.replace('{!Contact.Name}', ct.FirstName);
                htmlBody = htmlBody.replace('{!Invoice__c.Name}', invDetails.Name);       
                
                String plainBody = et.Body;
                system.debug('invDetails.Name'+invDetails.Name);
                plainBody = plainBody.replace('{!Contact.Name}', ct.FirstName);
                plainBody = plainBody.replace('{!Invoice__c.Name}', invDetails.Name);
                mail.setPlainTextBody(plainBody);
                mail.setSubject(subject);
                mail.setHtmlBody(htmlBody);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
                //mail.setHtmlBody(body);
                
                // Step 5. Add to list
                mails.add(mail);
            }
            
            //Step 6: Send all collected emails
            Messaging.sendEmail(mails);
        }catch(Exception e){
            System.debug('Error Line==>'+e.getLineNumber()+'Error Message==>'+e.getMessage());
        }
        
    }
    @AuraEnabled
    global static void sendCurrentInvoiceToCustomer(string accId) {
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            List<Account> customerRecord = [SELECT Email__c,First_Name__c,Last_Name__c,Name FROM Account WHERE Id =: accId AND Email__c != null];
            system.debug(customerRecord);
            
            Invoice__c invDetails = [select name,Due_Date__c from Invoice__c where Account__r.id =:accId  ORDER BY CreatedDate DESC NULLS LAST limit 1];
            
            EmailTemplate et=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = 'Send Invoice To Customer' limit 1];
            Attachment files = [SELECT Name, Body, ContentType FROM Attachment WHERE ParentId =:accId ORDER BY CreatedDate DESC NULLS LAST limit 1 ];
            
            system.debug('mails'+mails);
            if(!customerRecord.isEmpty()){
                for (Account customer : customerRecord) {
                    List<String> recipients = new List<String>();
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    
                    efa.setFileName(files.Name);
                    efa.setBody(files.Body);
                    efa.setContentType(files.ContentType);
                    
                    recipients.add(customer.Email__c);
                    mail.setToAddresses(recipients);
                    mail.setReplyTo('test@email.com');
                    mail.setSenderDisplayName('Test Organization');
                    
                    String htmlBody = et.HtmlValue;
                    htmlBody = htmlBody.replace('{!Customer.FirstName}', customer.First_Name__c != null? customer.First_Name__c : customer.Name);
                    htmlBody = htmlBody.replace('{!Customer.LastName}', customer.Last_Name__c != null? customer.Last_Name__c:'');
                    htmlBody = htmlBody.replace('{!Invoice__c.Name}', invDetails.Name != null ? invDetails.Name :'' );       
                    mail.setHtmlBody(htmlBody);
                    
                    String plainBody = et.Body;
                    plainBody = plainBody.replace('{!Customer.FirstName}', customer.First_Name__c != null? customer.First_Name__c : customer.Name);
                    plainBody = plainBody.replace('{!Customer.LastName}', customer.Last_Name__c != null? customer.Last_Name__c:'');
                    plainBody = plainBody.replace('{!Invoice__c.Name}', invDetails.Name != null ? invDetails.Name :'' );  
                    mail.setPlainTextBody(plainBody);
                    
                    String subject = et.Subject;
                    mail.setSubject(subject);
                    
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
                    mails.add(mail);
                }
                if(!mails.isEmpty()){
                    Messaging.sendEmail(mails);
                } 
            }            
        }
        catch(Exception e){
            System.debug('Error Line==>'+e.getLineNumber()+'Error Message==>'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static String convertNumberToMonth(integer monthIntVal){
        String month = '';
        if(monthIntVal > 0 && monthIntVal <13){
            
            if(monthIntVal == 1){
                month =  'January';   
            }else if(monthIntVal == 2){
                month = 'February';   
            }else if(monthIntVal == 3){
                month = 'March';   
            }else if(monthIntVal == 4){
                month = 'April';   
            }else if(monthIntVal == 5){
                month = 'May';       
            }else if(monthIntVal == 6){            
                month = 'June';   
            }else if(monthIntVal == 7){
                month = 'July';   
            }else if(monthIntVal == 8){
                month = 'August';   
            }else if(monthIntVal == 9){
                month = 'September';   
            }else if(monthIntVal == 10){
                month = 'October';  
            }else if(monthIntVal == 11){
                month = 'November';  
            }else{
                month = 'December';
            }
        }
        return month;
    }
    
    public class projectMappingWrapper {
        public String resourceName{get;set;}
        public String resourceRole{get;set;}
        public Decimal resourceEfforts{get;set;}
        public Decimal resourcePrice{get;set;}
        public Decimal resourceOutcome{get;set;}
        
        public projectMappingWrapper(String resourceName, String resourceRole, Decimal resourceEfforts,Decimal resourcePrice,Decimal resourceOutcome){
            this.resourceName = resourceName;
            this.resourceRole = resourceRole;
            this.resourceEfforts = resourceEfforts;
            this.resourcePrice = resourcePrice;
            this.resourceOutcome = resourceOutcome;
        }
    }
    
}