global class BatchToCreateCaseFromTweets implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    global string searchValue = 'MahindraRise';
    global List<Case> caseList = new List<Case>();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Subject FROM case';
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<case> scope)
    {
        list<Case> newCases = new List<Case>();
        List<String> TweetIds = new List<String>();
        if(scope.size() > 0){
            for(case cs : scope)
            {
                //TweetIds.add(cs.Tweet_Id__c);   
            }    
        }
        
        system.debug('TweetIds'+TweetIds);
        
        String url = 'https://api.twitter.com/1.1/search/tweets.json?q=%40'+searchValue+'&result_type=recent';
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();
        
        req.setHeader('Authorization', 'Bearer AAAAAAAAAAAAAAAAAAAAAM6gmgEAAAAAaVDULlddq77SSvoPogKajdFtsdo%3DHr42DnlEtkma4sHfXfni0nS6LbqlFH0x52Wl7N3wSmlqhsZGS0');
        req.setEndpoint(url);
        req.setMethod('GET');
        HTTPResponse res = http.send(req); 
        System.debug(res.getBody());
        /*system.debug('Wrapper Value'+(TwitterResponseDemo) System.JSON.deserialize(res.getBody(), TwitterResponseDemo.class));
        TwitterResponseDemo response = new TwitterResponseDemo();
        response = (TwitterResponseDemo) System.JSON.deserialize(res.getBody(), TwitterResponseDemo.class);
        system.debug(response.statuses);
        for(TwitterResponseDemo.statuses st : response.statuses){
            if(TweetIds.size() > 0){
                if(TweetIds.Contains(String.valueOf(st.id))){
                    
                }else{
                    Case newCase = new case();
                    newCase.tweet_related_to__c = searchValue;
                    newCase.Origin = 'Twitter';
                    //newCase.Tweet_Id__c = String.valueOf(st.id);
                    //system.debug('st.created_at'+st.created_at.substring(0,20));
                    //newcase.Tweet_Created_Time__c = st.created_at.substring(0,20);
                    //newcase.Tweet_URL__c = 'https://twitter.com/'+searchValue+'/status/'+String.valueOf(st.id);
                    //newcase.Tweet_Comments__c = st.text;
                    newcase.OwnerId = '0052v00000jEDHOAA4';
                    newcase.Priority = 'High';
                    newcase.Type = 'Problem';
                    newcase.Subject = 'This case is coming from twitter.';
                    caseList.add(newCase);
                }
            }else{
                Case newCase = new case();
                //newCase.tweet_related_to__c = searchValue;
                newCase.Origin = 'Twitter';
                //newCase.Tweet_Id__c = String.valueOf(st.id);
                //newcase.Tweet_Comments__c = st.text;
                newcase.OwnerId = '0052v00000jEDHOAA4';
                newcase.Priority = 'High';
                newcase.Type = 'Problem';
                newcase.Subject = 'Defamation / property infringement';
                caseList.add(newCase);
            }
            
        }
        //insert newCases;*/
    }
    global void finish(Database.BatchableContext BC) {
        system.debug('the case list is '+caseList);
        insert caseList;
    }
}