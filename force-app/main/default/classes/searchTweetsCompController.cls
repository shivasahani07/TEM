public class searchTweetsCompController {
    @AuraEnabled
    public Static List<relatedTweetData> searchTweets(String searchValue){
        
        searchValue.replaceAll('#','%23');
        system.debug('Value is '+searchValue);
        List<relatedTweetData> relatedTweetDataList = new List<relatedTweetData>();
        String url = 'https://api.twitter.com/2/tweets/search/recent?query='+searchValue+'&tweet.fields=in_reply_to_user_id,author_id,created_at';
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();
        
        req.setHeader('Authorization', 'Bearer AAAAAAAAAAAAAAAAAAAAAG0NpAEAAAAAvEJkx3U19PevFPDcm%2B9e81Fu0yM%3DswN8Gplc0UAVxdR1AYyQqHKtN0YlIiYGQEnM0Ll8BWroDNp4qv');
        req.setEndpoint(url);
        req.setMethod('GET');
        HTTPResponse res = http.send(req); 
        System.debug(res.getBody());
        //system.debug('Wrapper Value'+(TwitterResponseDemo) System.JSON.deserialize(res.getBody(), TwitterResponseDemo.class));
        
        TwitterTweetWrapper tweetWrapper = (TwitterTweetWrapper)JSON.deserialize(res.getBody(), TwitterTweetWrapper.class);
        List<TwitterTweetWrapper.TweetData> tweets = tweetWrapper.data;
        // Loop through the tweets and access their properties
        for (TwitterTweetWrapper.TweetData tweet : tweets) {
            relatedTweetData response = new relatedTweetData();
            response.tweetId = tweet.id;
            response.tweetMessage = tweet.text;
			response.tweetURL = 'https://twitter.com/'+searchValue+'/status/'+tweet.id;
			response.createdAt = tweet.created_at;
			response.replyToname = '';//st.in_reply_to_screen_name;
            relatedTweetDataList.add(response);
        }
        system.debug('relatedTweetDataList==>'+relatedTweetDataList.size());
        return relatedTweetDataList;//(TwitterResponseDemo) System.JSON.deserialize(res.getBody(), TwitterResponseDemo.class);
        
    }
    
    @AuraEnabled
    public static void sendReplyToTheTweet(String tweetId , String message){
        system.debug('tweetId is'+tweetId);
        system.debug('message is'+message);
        message = message.replaceAll('<[^>]+>',' ');
        case ca = [SELECT Id,Subject,Related_to__c,Comment_Replied__c FROM case limit 1];
        ca.Comment_Replied__c = message;
        
        Map<String, String> encodeParams = new Map<String, String>();   
        encodeParams.put('in_reply_to_status_id', tweetId);
        encodeParams.put('auto_populate_reply_metadata', 'true');
        
        String clientId = 'Nk9tcFJGbjg1VGNfVTYzRklEVGU6MTpjaQ';
        String clientSecret = 'x4g5iWxpzYv46jlK18xdKHiGmfwKC9ESGWN9xU0Kb5qxlJhukR';
        
        String ApiKey = 'kJe4OzK41VsknvAwbtpE32CWW';
        String ApiSecret = 'aND7tmp07kU335C7g2U7GVk2Gu9rTG7zGl7jBLLwDrO9GEcrTI';
        String AccessToken = '1663898120684711943-qP7y7D7K9GEi5cML927L12h3WIh6Ty';
        String AccessTokenSecret = 'Yxha2lWjm9yD2qwtzvOVGpGs9IIoKlgJHkCd6k1bjXKy0';
        String bearerToken = 'AAAAAAAAAAAAAAAAAAAAAG0NpAEAAAAAz6IRdXKrxcmKWXMrRlrTsjmrxHU%3DCXmVKum0Wfen0lQRIFjk2lC7pwFJdfqY3sVHX0X59Ihil8qgsl';
        TweetUtil tu = new TweetUtil(ApiKey,ApiSecret,AccessToken,AccessTokenSecret);
        tu.sendTweet(message,encodeParams,ca);
        //update ca;
    }
    
    @AuraEnabled
    public static case FetchBasicCaseDetails(String caseId){
        system.debug('caseId is'+caseId);
        Case caseRec = [SELECT Id,Subject,Related_to__c,Comment_Replied__c FROM case where id = :caseId];
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