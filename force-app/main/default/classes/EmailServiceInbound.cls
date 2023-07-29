global class EmailServiceInbound implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String myPlainText= '';
        // Add the email plain text into the local variable 
        myPlainText = email.plainTextBody;        
        system.debug('####unique message ID##'+email.messageId);
        
        // For storing Relation Id
        string oppcid ='';
        
        string sss= email.subject;
        System.debug('sss '+ sss);
        string [] a = sss.split('\\(');
        system.debug('a0 ='+ a[0]);
        //system.debug('a1 a[1]);
        string [] bb = a[1].split('\\)');
        system.debug('bb>>>Final ID>>>> '+bb[0] );
        string subrecid = bb[0] ;       
        
        If (subrecid.startsWith('003')){
            //Add Inbound Email Message for contact
            EmailMessage conEmailMessage = new EmailMessage();
            conEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            conEmailMessage.FromAddress = email.FromAddress;
            conEmailMessage.FromName = email.FromName;
            conEmailMessage.Subject = email.subject;
            conEmailMessage.status = '2';
            conEmailMessage.HtmlBody = email.htmlBody;
            System.debug('htmlBody:>>>> ' + email.htmlBody );
            conEmailMessage.Incoming= True;
            conEmailMessage.TextBody = email.plainTextBody;
            System.debug('TextBody:>>>>> ' + email.plainTextBody);
            conEmailMessage.Contact__c =subrecid;
            insert conEmailMessage;
            System.debug('Reply Email: ' + conEmailMessage ); 
            
            // Add Email Message Relation for id of the sender
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = conEmailMessage.id;
            emr.RelationId = subrecid;// user id of the sender
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
            insert emr; 
            system.debug('>>>>>=='+ emr );
        }else{
            
        }
        
        if(subrecid.startsWith('00Q')) {
            //Add Inbound Email Message for Lead
            EmailMessage leadEmailMessage = new EmailMessage();
            leadEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            leadEmailMessage.FromAddress =  email.FromAddress;
            leadEmailMessage.FromName = email.FromName;
            leadEmailMessage.Subject = email.subject;
            leadEmailMessage.status = '2';
            leadEmailMessage.HtmlBody = email.htmlBody;
            System.debug('htmlBody:>>>> ' + email.htmlBody );
            leadEmailMessage.Incoming= True;
            leadEmailMessage.TextBody = email.plainTextBody;
            System.debug('TextBody:>>>>> ' + email.plainTextBody);
            leadEmailMessage.Lead__c = subrecid;
            insert leadEmailMessage;
            System.debug('Reply Email: ' + leadEmailMessage ); 
            
            // Add Email Message Relation for id of the sender
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = leadEmailMessage.id;
            emr.RelationId = subrecid; 
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
            insert emr; 
            system.debug('>>>>>=='+ emr );
        }else{
            Lead ld = new lead();
            ld.FirstName = email.FromName;
            ld.LastName = '';
            ld.Company = '';
            ld.Email = email.FromAddress;
            insert Ld;
            system.debug('Ld'+Ld);
        }
        
        if(subrecid.startsWith('001')) {
            
        }
        
        if(subrecid.startsWith('006')){
            //Add Inbound Email Message for Opportunity
            EmailMessage oppEmailMessage = new EmailMessage();
            oppEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            oppEmailMessage.FromAddress =  email.FromAddress;
            oppEmailMessage.FromName = email.FromName;
            oppEmailMessage.Subject = email.subject;
            oppEmailMessage.status = '2';
            oppEmailMessage.HtmlBody = email.htmlBody;
            oppEmailMessage.Incoming= True;
            oppEmailMessage.TextBody = email.plainTextBody;
            oppEmailMessage.Opportunity__c = subrecid;
            insert oppEmailMessage;
            System.debug('Reply Email: ' + oppEmailMessage ); 
            
            // Add Email Message Relation for id of the sender
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = oppEmailMessage.id;
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
            List<OpportunityContactRole>passid = [select id,ContactId,IsPrimary,OpportunityId,Role from OpportunityContactRole where OpportunityId=: subrecid];
            for (OpportunityContactRole opc : passid ){
                oppcid = opc.ContactId;
            }
            system.debug('#####'+ oppcid);
            emr.RelationId = oppcid;
            
            insert emr;  
            system.debug('>>>>>=='+ emr );           
        }else{
            
        }
        
       
        return result;
    }
}