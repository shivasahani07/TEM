public class UserNotification {
    Public Static void notifyUserOnNewComment(List<Post_Comments__c> newCommentsList){
        for(Post_Comments__c pcmnts:newCommentsList ){
            customUsrNotification(pcmnts.id,'New_Comment');
        }
    }
    
    Public Static void customUsrNotification(String setTargetId,String CustomNotificationName){
        	Post_Comments__c commentRec=[SELECT id,Name,Case__c,Case__r.CaseNumber FROM Post_Comments__c WHERE id=:setTargetId];
        
        try{
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setBody('Case Number:-'+commentRec.Case__r.CaseNumber);
            notification.setTitle('This case has new comments-');
            notification.setSenderId(Userinfo.getUserId());
            CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName =:CustomNotificationName];
            notification.setNotificationTypeId(type.id);
            notification.setTargetId(commentRec.Case__c); // target object id
            notification.send(new Set<String> { Userinfo.getUserId()});
        }
        catch(exception e){
            system.debug('Error Message-'+e.getMessage()+' && error Line '+e.getLineNumber());
        }
    }
    
    
    
    Public static void updateCaseRealTimeByPostId(List<Post_Comments__c> newComments){
        
        for(Post_Comments__c pcmmnt:newComments){
            New_Comments__e pushNewComments = new New_Comments__e();
            //pushNewComments.PostId__c=pcmmnt.
            pushNewComments.CaseId__c=pcmmnt.Case__c;
        }
        
    }
    
}