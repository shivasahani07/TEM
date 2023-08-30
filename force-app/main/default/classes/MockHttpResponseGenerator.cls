@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, you can check the endpoint and method to return different responses
        // For example, handle different callouts based on the endpoint and method
        if (req.getMethod() == 'GET') {
            if (req.getEndpoint() == 'http://example.com/example/test') {
                // Create a fake response for GET request to http://example.com/example/test
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"example":"test"}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint() == 'http://example.com/example/another') {
                // Create a fake response for GET request to http://example.com/example/another
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"example":"another"}');
                res.setStatusCode(200);
                return res;
            }
        }

        // If the endpoint and method do not match any of the above conditions, return an empty response.
        return new HttpResponse();
    }
    
    @isTest
    static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       
        // Call the method that performs the HTTP callout
        // Add your method call here...
        instaWebhookApi.webhookListener();
    }
}