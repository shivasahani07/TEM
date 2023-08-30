global class NewMockHttpResponseGenerator {
      // Override the respond method to simulate HTTP callouts and return predefined responses
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setHeader('Content-Type', 'application/json');

        // Get the endpoint URL and check for specific scenarios
        String endpointUrl = request.getEndpoint();

        // Test different scenarios based on the endpoint URL
        if (endpointUrl.contains('ig_hashtag_search')) {
            // Simulate a successful response for getHashtagIdFromInsta() method
            String jsonResponse = '{"data":[{"Id":"12345"}]}';
            httpResponse.setBody(jsonResponse);
            httpResponse.setStatusCode(200);
        } else if (endpointUrl.contains('recent_media')) {
            // Simulate a successful response for getPostDetailsByHashTagId() method
            String jsonResponse = '{"data":[{"id":"123","permalink":"https://instagram.com/post/123"}]}';
            httpResponse.setBody(jsonResponse);
            httpResponse.setStatusCode(200);
        } else if (endpointUrl.contains('comments/')) {
            // Simulate a successful response for getAllDetailsOfComments() method
            String jsonResponse = '{"media":{"id":"456"}}';
            httpResponse.setBody(jsonResponse);
            httpResponse.setStatusCode(200);
        } else if (endpointUrl.contains('media/')) {
            // Simulate a successful response for getAllDetailsOfMedia() method
            String jsonResponse = '{"id":"456","caption":"Test post"}';
            httpResponse.setBody(jsonResponse);
            httpResponse.setStatusCode(200);
        } else if (endpointUrl.contains('comments/123/replies')) {
            // Simulate a successful response for replyToComment() method
            String jsonResponse = '{"id":"789","text":"This is a reply","username":"test_user"}';
            httpResponse.setBody(jsonResponse);
            httpResponse.setStatusCode(200);
        } else {
            // Simulate an error response for unknown endpoints
            httpResponse.setStatusCode(404);
        }

        return httpResponse;
    }

}