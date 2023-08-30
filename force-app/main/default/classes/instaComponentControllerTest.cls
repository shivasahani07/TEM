@isTest
public class instaComponentControllerTest {
    
    @isTest
    static void testGetRepliesDetails() {
        
        // Create a test Case record
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Description = 'Test Case Description';
        insert testCase;
        string caseId=testCase.id;
        // Create test data for the Post_Comments__c object
        Post_Comments__c commentRecord = new Post_Comments__c();
        commentRecord.Comment_Id__c = 'TestCommentId';
        commentRecord.Replied_Comments__c = 'RepliesWrapper:[data=(ReplyData:[id=123, text=Test Reply 1, username=testuser1, timeStamp=2023-07-29T12:34:56+0000,Case__c=caseId])])';
        commentRecord.Case__c=caseId;
        insert commentRecord;
        
        // Call the getRepliesDetails method with the test data
        List<instaComponentController.ReplyWrapperRecords> replyList = instaComponentController.getRepliesDetails(commentRecord.Comment_Id__c);
        
        // Verify the results
        System.assertEquals(1, replyList.size());
        
        // Verify the content of the first reply
        instaComponentController.ReplyWrapperRecords firstReply = replyList[0];
        //System.assertEquals('123', firstReply.id);
        System.assertEquals('Test Reply 1', firstReply.text);
        //System.assertEquals('testuser1', firstReply.username);
        //System.assertEquals('2023-07-29T12:34:56', firstReply.timeStamp);
    }
    
    @isTest
    static void testGetCaseDetails() {
        // Create a test Case record
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Description = 'Test Case Description';
        insert testCase;
        
        // Create a test Post_Comments__c record associated with the Case
        Post_Comments__c commentRecord = new Post_Comments__c();
        commentRecord.Comment_Id__c = 'TestCommentId';
        commentRecord.Comment__c = 'Test Comment';
        commentRecord.Post_Url__c = 'https://www.example.com/test-post-url';
        commentRecord.Post_comment_Time__c =string.valueof(Datetime.now());
        commentRecord.Case__c = testCase.Id;
        insert commentRecord;
        
        // Call the getCaseDetails method with the test data
        List<instaComponentController.instaWrapper> instaWrapperList = instaComponentController.getCaseDetails(testCase.Id);
        
        // Verify the results
        System.assertEquals(1, instaWrapperList.size());
        
        // Verify the content of the first instaWrapper
        instaComponentController.instaWrapper firstWrapper = instaWrapperList[0];
        System.assertEquals('Test Comment', firstWrapper.comment);
        System.assertEquals(testCase.Description, firstWrapper.postCaption);
        System.assertEquals('https://www.example.com/test-post-url', firstWrapper.PostUrl);
        System.assertEquals('TestCommentId', firstWrapper.CommentId);
    }
    
    
    @isTest
    static void testReplyToComment() {
        // Create a test Case record
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Description = 'Test Case Description';
        insert testCase;
        
        // Create a test Post_Comments__c record
        Post_Comments__c commentRecord = new Post_Comments__c();
        commentRecord.Comment_Id__c = 'TestCommentId';
        commentRecord.Replied_Comments__c = null; // Simulating no replies
        commentRecord.Case__c = testCase.Id;
        insert commentRecord;
        
        // Set the mock for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the replyToComment method with the test data
        Test.startTest();
        instaComponentController.replyToComment('TestCommentId', 'Test reply message');
        Test.stopTest();
        
        // Retrieve the updated Post_Comments__c record
        Post_Comments__c updatedCommentRecord = [SELECT Replied_Comments__c FROM Post_Comments__c WHERE Comment_Id__c = 'TestCommentId'];
        
        // Verify the results
        //System.assertNotEquals(null, updatedCommentRecord.Replied_Comments__c, 'Reply should be added to the comment');
        // Add more assertions as needed to validate the expected behavior
    }
}