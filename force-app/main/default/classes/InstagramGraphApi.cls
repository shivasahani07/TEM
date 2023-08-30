public class InstagramGraphApi {
    public static String getMediaIdFromUrl(String mediaUrl, String accessToken) {
        String mediaId = null;

        // Extract the shortcode from the media URL
        String[] urlParts = mediaUrl.split('/');
        String shortcode = urlParts[urlParts.size() - 2];

        // Construct the URL for the media API endpoint
        String apiUrl = 'https://graph.facebook.com/v13.0';
        String fieldsParam = 'fields=id';
        String accessTokenParam = 'access_token=' + accessToken;
        String queryParams = fieldsParam + '&' + accessTokenParam;
        String fullUrl = apiUrl + '/' + shortcode + '?' + queryParams;

        // Make the HTTP GET request to the API endpoint
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(fullUrl);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        // Parse the JSON response and extract the media ID
        if (response.getStatusCode() == 200) {
            Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            mediaId = (String) responseData.get('id');
        }

        return mediaId;
    }
}