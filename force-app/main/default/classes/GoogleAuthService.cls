public class GoogleAuthService {
    //API Secret Key
    private static string key = '928840737068-joh463pqsr7nt4su15o966jmi3dmjouo.apps.googleusercontent.com';
    //API Secret
    private Static string secert = 'g8xNZwD6tGrNHYep7LdGjvQS';
    //API Redirect. Use your Lightning Tab or Lightning community URL
    private Static string redirect_uri = 'https://sales-production.lightning.force.com/lightning/n/Google_Auth';
    private static string authUrl='https://accounts.google.com/o/oauth2/v2/auth';
    private static string scope='https://www.googleapis.com/auth/calendar';
    private static string tokenUrl='https://accounts.google.com/o/oauth2/token';
    
    @AuraEnabled
    public static String createAuthURL() {
        String key = EncodingUtil.urlEncode(key,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = authUrl+'?'+
            'client_id='+key+
            '&response_type=code'+
            '&scope='+scope+
            '&redirect_uri='+uri+
            '&access_type=offline'+
            '&prompt=consent';
        return authuri;
    }
    
    @AuraEnabled
    public static boolean getAccessToken(String code)
    {
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(tokenUrl);
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        
        String messageBody ='code='+code+'&client_id='+key+
            '&client_secret='+secert+
            '&redirect_uri='+redirect_uri+
            '&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
        system.debug('messageBody:'+messageBody);
        
        Http callout = new Http();
        String responseText;
        HttpResponse response = callout.send(req);
        responseText = response.getBody();
        system.debug('responseText:'+responseText);
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;  
        String token =  String.valueOf(responseMap.get('access_token'));
        system.debug('token:'+token);
        
        //Update token in custom metadata 
        MetadataService.UpdateCustomMetadata(token);
        return true;
        
    }
}