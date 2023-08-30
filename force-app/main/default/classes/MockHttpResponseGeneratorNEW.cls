@isTest
private class MockHttpResponseGeneratorNEW implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
        // Create a mock HTTP response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setStatus('OK');
        response.setBody('{"id": "Comment123"}');
        return response;
    }
}