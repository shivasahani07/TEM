/*
* Author : DeaGle~
*/
public without sharing class MetaAuthHandler {

    private static final String CLIENT_ID;
    private static final String CLIENT_SECRET;

    private static final String API_GET_ME = '/me/accounts?access_token=';
    private static final String API_ACCESS_TOKEN = '/oauth/access_token';

    private static final String REDIRECT_URI = 'https://sales-production--sales.sandbox.my.salesforce-sites.com';

    static {
        Meta_App_Credentials__c credentials = Meta_App_Credentials__c.getAll() != null ? Meta_App_Credentials__c.getAll().get('development') : null; //TODO: make this dynamic
        if(credentials != null) {
            CLIENT_ID = credentials.App_Id__c;
            CLIENT_SECRET = credentials.App_Secret__c;
        }
    }

    

    public static String getAccessToken() {
        String appToken = CLIENT_ID + ':' + CLIENT_SECRET;
        //String endpointUrl, Map<String, String> queryParams, Map<String, String> headers
        //new Map<String,String> {'client_id' => CLIENT_ID, 'client_secret' => CLIENT_SECRET, 'redirect_uri' => REDIRECT_URI}
        HttpResponse appTokenResponse = DynamicHttpCallout.makeHttpGetCallout('callout:meta' + API_ACCESS_TOKEN + '?client_id=' + CLIENT_ID + '&client_secret=' + CLIENT_SECRET, null, null);
        System.debug('--- appTokenResponse: '+appTokenResponse);
        if(appTokenResponse != null && appTokenResponse.getStatusCode() == 200) {
            return appTokenResponse.getBody();
        }
        return null;
    }

    public static String getMyAccounts(String accessToken) {
        return null;
    }


/*
API = 103319499517877/subscribed_apps?access_token=EAAKJz6xiZC6gBO8k2KQIgwYnjBhH2UWdr911sGoN7tNxIotNbkLwr8ZAS5AaTxFxpsxpfyxEWSJbVmC06NkG4InrMofZAXJYGnaVRUkwDd2EuY4PI0Kl6YsDeVQmwV0jMVgpgtkZBk91RRE0vMUNVxq0OjcJPt1anWkIUtlvHDpcuP7aOWDd9wn6BZCeVoywQOoNKfcrnWvSh0EdCQl3RZCj0ZD&subscribed_fields=feed
{
  "data": [
    {
      "access_token": "EAAKJz6xiZC6gBACflZAgMhNVBgifajZCZC9mBrjWmCVRHBZBpniumzOopgAaBrTOEieItsZCP1OUudWDPKxMTGj4PehU2l9w1eQg4qOGOZA9swmCZC6US9IDUaeLSWmglf2WclPxp3IftLo6tZC5BZBRDvrwCEBiEvyOODEGldh9Sy51kDI4POAotzqy201xed2fHKPGs1rWETBTKGaC12DBAH",
      "category": "E-commerce website",
      "category_list": [
        {
          "id": "1756049968005436",
          "name": "E-commerce website"
        }
      ],
      "name": "Test Salesforce Integration",
      "id": "103319499517877",
      "tasks": [
        "ADVERTISE",
        "ANALYZE",
        "CREATE_CONTENT",
        "MESSAGING",
        "MODERATE",
        "MANAGE"
      ]
    }
  ],
  "paging": {
    "cursors": {
      "before": "QVFIUkxlbTNqOWRycENrUkJFd0JrREI5enpiRnoyMjI3VU04M2pQcVp3Wk4wdWNlTVF6bXNQOTlkRGp2djgtSmlWNHJsa1JHYTlYVDVEeVFEeFZAwb1daYktn",
      "after": "QVFIUkxlbTNqOWRycENrUkJFd0JrREI5enpiRnoyMjI3VU04M2pQcVp3Wk4wdWNlTVF6bXNQOTlkRGp2djgtSmlWNHJsa1JHYTlYVDVEeVFEeFZAwb1daYktn"
    }
  }
}
*/

}