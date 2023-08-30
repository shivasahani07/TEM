public class TwitterCommentApex {

    // Replace these values with your Twitter API credentials
    private static final String API_KEY = 'kJe4OzK41VsknvAwbtpE32CWW';
    private static final String BEARER_TOKEN = 'AAAAAAAAAAAAAAAAAAAAAG0NpAEAAAAAvEJkx3U19PevFPDcm%2B9e81Fu0yM%3DswN8Gplc0UAVxdR1AYyQqHKtN0YlIiYGQEnM0Ll8BWroDNp4qv';

    public static void postComment(String tweetId, String commentText) {
        String tweetUrl = 'https://api.twitter.com/2/tweets';
        
        // Create the comment text with the tweet ID as annotation
        String comment = commentText + ' {reply_settings: {force_reply: true}, in_reply_to_tweet_id: ' + tweetId + '}';
        
        Map<String, Object> tweetParams = new Map<String, Object>{
            'status' => comment
        };

        String tweetResponse = sendTwitterRequest(tweetUrl, 'POST', tweetParams);

        // Handle the tweet response as needed
        System.debug('Tweet Response: ' + tweetResponse);
    }

    private static String sendTwitterRequest(String url, String method, Map<String, Object> params) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        req.setHeader('Authorization', 'Bearer ' + BEARER_TOKEN);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(params));

        Http http = new Http();
        HttpResponse res = http.send(req);
        return res.getBody();
    }
}