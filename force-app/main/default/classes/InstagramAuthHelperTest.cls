@isTest
public class InstagramAuthHelperTest {
    
     @isTest
    static void testGetAllPostsFromInstaForUserId() {
        InstagramAuthHelper instance = new InstagramAuthHelper();
    }
    /*
    @isTest
    static void testGetHashtagIdFromInsta() {
        // Test data setup (if needed)
        // Create Instagram_Api_Details__c custom setting record with required data
        
        // Set up mock HTTP callouts
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to test
        Test.startTest();
        String hashtagId = InstagramAuthHelper.getHashtagIdFromInsta('testHashtag');
        Test.stopTest();
        
        // Assertions (verify that the returned hashtagId is as expected)
        // Example:
        // System.assertEquals(EXPECTED_HASHTAG_ID, hashtagId);
    }
    
     @isTest
    static void testGetPostDetailsByHashTagId() {
        // Test data setup (if needed)
        // Create Instagram_Api_Details__c custom setting record with required data

        // Set up mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to test
        Test.startTest();
        InstagramAuthHelper.getPostDetailsByHashTagId('testHashtag');
        Test.stopTest();

        // Assertions (verify that the expected data was inserted into Salesforce)
        List<Case> cases = [SELECT Id, Tweet_Id__c, Tweet_URL__c, Tweet_Comments__c FROM Case];
        System.assertEquals(1, cases.size());
        System.assertEquals('12345', cases[0].Tweet_Id__c);
        System.assertEquals('https://instagram.com/p/abc123', cases[0].Tweet_URL__c);
        System.assertEquals('{"data": [{"id": "54321", "text": "Test comment", "username": "commentuser", "timestamp": "2023-07-29T12:34:56Z", "replies": {"data": []}}]}', cases[0].Tweet_Comments__c);

        List<Post_Comments__c> postComments = [SELECT Id, Case__c, Comment__c, Comment_Id__c, Commented_By__c, Post_Url__c, Post_comment_Time__c, Replied_Comments__c FROM Post_Comments__c];
        System.assertEquals(1, postComments.size());
        System.assertEquals(cases[0].Id, postComments[0].Case__c);
        System.assertEquals('Test comment', postComments[0].Comment__c);
        System.assertEquals('54321', postComments[0].Comment_Id__c);
        System.assertEquals('commentuser', postComments[0].Commented_By__c);
        System.assertEquals('https://instagram.com/p/abc123', postComments[0].Post_Url__c);
        System.assertEquals('2023-07-29T12:34:56Z', postComments[0].Post_comment_Time__c);
        System.assertEquals('{"data": []}', postComments[0].Replied_Comments__c);
    }
    
      @isTest
     static void testReplyToComment() {
        // Test data setup (if needed)
        // Create Post_Comments__c record with required data for the comment to which you want to reply

        // Set up mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to test
        Test.startTest();
        InstagramAuthHelper.replyToComment('commentId', 'Test reply');
        Test.stopTest();

        // Assertions (verify that the reply is added to the comment)
        List<Post_Comments__c> postComments = [SELECT Id, Replied_Comments__c FROM Post_Comments__c];
        System.assertEquals(1, postComments.size());
        System.assertEquals('RepliesWrapper:[data=(ReplyData:[id=17987241320233933, text=Test%20reply, username=replyuser])]', postComments[0].Replied_Comments__c);
    }
    // Write similar test methods for other methods in InstagramAuthHelper class
    // */
}