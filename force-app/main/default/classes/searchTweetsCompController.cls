public class searchTweetsCompController {
    
    //https://api.twitter.com/1.1/search/tweets.json?q=%40Herbalifeindia&result_type=recent
    //Bearer Token : AAAAAAAAAAAAAAAAAAAAAM6gmgEAAAAAaVDULlddq77SSvoPogKajdFtsdo%3DHr42DnlEtkma4sHfXfni0nS6LbqlFH0x52Wl7N3wSmlqhsZGS0
    @AuraEnabled
    public Static List<relatedTweetData> searchTweets(String searchValue){
        system.debug('Value is '+searchValue);
        List<relatedTweetData> relatedTweetDataList = new List<relatedTweetData>();
        String url = 'https://api.twitter.com/1.1/search/tweets.json?q=%40'+searchValue+'&result_type=recent';
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();
        
        req.setHeader('Authorization', 'Bearer AAAAAAAAAAAAAAAAAAAAAM6gmgEAAAAAaVDULlddq77SSvoPogKajdFtsdo%3DHr42DnlEtkma4sHfXfni0nS6LbqlFH0x52Wl7N3wSmlqhsZGS0');
        req.setEndpoint(url);
        req.setMethod('GET');
        HTTPResponse res = http.send(req); 
        System.debug(res.getBody());
        system.debug('Wrapper Value'+(TwitterResponseDemo) System.JSON.deserialize(res.getBody(), TwitterResponseDemo.class));
        TwitterResponseDemo response = new TwitterResponseDemo();
        response = (TwitterResponseDemo) System.JSON.deserialize(res.getBody(), TwitterResponseDemo.class);
        system.debug(response.statuses);
        for(TwitterResponseDemo.statuses st : response.statuses){
            relatedTweetData rtd = new relatedTweetData();
            rtd.tweetId = st.id_str;
            rtd.tweetMessage = st.text;
            rtd.replyToname = st.in_reply_to_screen_name;
            rtd.createdAt = st.created_at;
            rtd.tweetURL = 'https://twitter.com/'+searchValue+'/status/'+st.id_str;//https://twitter.com/TexasLindsay_/status/1646006232484913153
            relatedTweetDataList.add(rtd);
            system.debug('sadsad'+st.id);
        }
        system.debug('relatedTweetDataList'+relatedTweetDataList);
        return relatedTweetDataList;//(TwitterResponseDemo) System.JSON.deserialize(res.getBody(), TwitterResponseDemo.class);
        
    }
    
    @AuraEnabled
    public static void sendReplyToTheTweet(String tweetId , String message){
        system.debug('tweetId is'+tweetId);
        system.debug('message is'+message);
        message = message.replaceAll('<[^>]+>',' ');
        case ca = [SELECT Id,Subject,tweet_related_to__c,Tweet_Comment_URL__c,Comment_Replied__c,Tweet_Comments__c,Tweet_Id__c FROM case where Tweet_Id__c = :tweetId order by createdDate DESC LIMIT 1];
        ca.Comment_Replied__c = message;
        
        Map<String, String> encodeParams = new Map<String, String>();   
        encodeParams.put('in_reply_to_status_id', tweetId);
        encodeParams.put('auto_populate_reply_metadata', 'true');
        
        String ApiKey = 'rbfyDgklaWxTzodtFUSkAKJSu';
        String ApiSecret = '9naQVl6QQvTz5cHtQGDrsNOkV2isYvLVnUMBFADwDW65aHYioD';
        String AccessToken = '1645861686207983616-NlXc7nzKbpxVtJ60cXNxGrvHdK4MSi';
        String AccessTokenSecret = 'tBO5yp8pey0MjUVuekTJGJYtNfgCz4RB8X5vAhllE6dew'; 
        TweetUtil tu = new TweetUtil(ApiKey,ApiSecret,AccessToken,AccessTokenSecret);
        tu.sendTweet(message,encodeParams,ca);
        //update ca;
    }
    
    @AuraEnabled
    public static case FetchBasicCaseDetails(String caseId){
        system.debug('caseId is'+caseId);
        Case caseRec = [SELECT Id,Subject,tweet_related_to__c,Tweet_Comments__c,Comment_Replied__c,Tweet_Id__c FROM case where id = :caseId];
        return caseRec;
    }
    
    Public class relatedTweetData {
        @AuraEnabled public String tweetId;
        @AuraEnabled public String tweetMessage;
        @AuraEnabled public String replyToname;
        @AuraEnabled public String createdAt;
        @AuraEnabled public string tweetURL;
    }
    
}