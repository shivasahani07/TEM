public class TwitterPost_Utility 
{    
    Public Static String ApiKey = 'rbfyDgklaWxTzodtFUSkAKJSu';
    Public Static String ApiSecret = '9naQVl6QQvTz5cHtQGDrsNOkV2isYvLVnUMBFADwDW65aHYioD';
    Public Static String AccessToken = '1645861686207983616-NlXc7nzKbpxVtJ60cXNxGrvHdK4MSi';
    Public Static String AccessTokenSecret = 'tBO5yp8pey0MjUVuekTJGJYtNfgCz4RB8X5vAhllE6dew'; 
    //String message = 'My frist tweet Via APi is working Fine--!!-->';
    
    public static void twitterPost(String message)
    {
        if(String.isNotBlank(ApiKey) && String.isNotBlank(ApiSecret) && String.isNotBlank(AccessToken) && String.isNotBlank(AccessTokenSecret) && String.isNotBlank(message))
        {
            String oathNonce = generateOathNonce();
            Long timestamp   = generateTimeStamp();
            String signature = '';
            
            message = Encodingutil.urlEncode(message, 'UTF-8');
            String othSecret = Encodingutil.urlEncode(Accesstokensecret, 'UTF-8');
            String consumSecret = Encodingutil.urlEncode(APIsecret, 'UTF-8');
            String othToken = Encodingutil.urlEncode(Accesstoken, 'UTF-8');
            String othNonce = Encodingutil.urlEncode(oathNonce, 'UTF-8');
            String consumKey = Encodingutil.urlEncode(APIkey, 'UTF-8');
            message = message.replaceAll('\\+','%20');
            String paramString = 'include_entities=true&'+
                'oauth_consumer_key='+consumKey+'&'+
                'oauth_nonce='+othNonce+'&'+
                'oauth_signature_method=HMAC-SHA1&'+
                'oauth_timestamp='+timestamp+'&'+
                'oauth_token='+othToken+'&'+
                'oauth_version=1.0&'+
                'status='+message+'&'+
                'in_reply_to_status_id=1646223597432864770';
            string baseString = 'POST&'+EncodingUtil.urlEncode('https://api.twitter.com/1.1/statuses/update.json', 'UTF-8')+'&'+ 
                EncodingUtil.urlEncode(paramString, 'UTF-8');
            system.debug('### baseString :'+baseString);
            string signString = consumSecret+'&'+othSecret;
            system.debug('### signString :'+signString);
            blob blobBaseString = Blob.ValueOf(baseString);
            blob blobSignString = Blob.ValueOf(signString);
            blob signBlob = crypto.generateMac('hmacSHA1',blobBaseString ,blobSignString );        
            signature =  EncodingUtil.base64Encode(signBlob);
            system.debug('### Sign :'+signature);
            
            if(String.isNotBlank(signature))
            {
                signature = Encodingutil.urlEncode(signature, 'UTF-8');
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://api.twitter.com/1.1/statuses/update.json?include_entities=true');
                req.setMethod('POST');
                string reqstring = 'OAuth oauth_consumer_key="'+consumKey+'",'+
                    'oauth_nonce="'+othNonce+'",'+
                    'oauth_signature="'+signature +'",'+
                    'oauth_signature_method="HMAC-SHA1",'+
                    'oauth_timestamp="'+timestamp+'",'+
                    'oauth_token="'+othToken+'",'+
                    'in_reply_to_status_id="1646223597432864770",'+
                    'oauth_version="1.0"';
                system.debug('### req String :'+reqstring);
                req.setHeader('Authorization',reqstring);
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                req.setBody('status='+message);
                if(!Test.isRunningTest())
                {
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    system.debug(res.getBody());
                    system.debug('The Deserialised response : '+ (twitterResponseWrapper) System.JSON.deserialize(res.getBody(), twitterResponseWrapper.class) );
                }
            }
        }
    }
    
    public static String generateOathNonce()
    {
        Blob blobKey = crypto.generateAesKey(256);
        String key = EncodingUtil.convertToHex(blobKey);
        String oathNonce = EncodingUtil.base64Encode(Blob.valueOf(key));
        oathNonce = oathNonce.replaceAll('[^a-zA-Z0-9]+',''+integer.valueOf(math.random() * 10));
        oathNonce = oathNonce.substring(0,42);
        return oathNonce;
    }
    
    //method to generate current timestamp in seconds
    public static long generateTimeStamp()
    {
        long timestamp = datetime.now().getTime(); 
        timestamp = timestamp / 1000;
        return timestamp;
    }
}