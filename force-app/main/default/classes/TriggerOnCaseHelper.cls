public class TriggerOnCaseHelper {

    public static void getRepliesForTweet(List<Case> newCaseList){
        for(Case caseRec : newCaseList){
            if(caseRec.Origin == 'Twitter')
	            twitterApis.getAllCommentsRelatedToTweet(caseRec.Post_Id__c);    
        }
        
    }
    
}