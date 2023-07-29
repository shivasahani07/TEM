public class EmailApexClass {
    
    
    Public static void sendNotification(contact contact)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(contact.id);
        message.setSenderDisplayName('Utilitarianlabs');
        message.setReplyTo('info@utilitarianlab.com');
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false);
        EmailTemplate emailTemplate =[Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Password Generation'];
        
        
        message.setTemplateID(emailTemplate.Id);
        //message.setWhoId(contact.Id); 
        message.setTargetObjectId(contact.Id);
        message.toAddresses = new String[] { contact.email};
            
            Messaging.SingleEmailMessage[] messages = new   
            List<Messaging.SingleEmailMessage> {message};
                
                Messaging.SendEmailResult[] results =
                Messaging.sendEmail(messages);
        
        if (results[0].success)
        {
            System.debug('The email was sent successfully.');
        }
        else
        {
            System.debug('The email failed to send: '+results[0].errors[0].message);
        }
    }
    
}