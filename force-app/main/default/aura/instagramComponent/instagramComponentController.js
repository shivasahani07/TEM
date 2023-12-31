({
    doInit : function(component, event, helper) {
        debugger;
        var recId = component.get("v.recordId");
        var action = component.get("c.getCaseDetails");
        var pageSize=component.get("v.pageSize");
        action.setParams({
            recordId: recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var paginationList = [];
                var temResult=[];
                var serverresponse = response.getReturnValue();
                component.set("v.tweetDescription",serverresponse[0].postCaption);
                component.set("v.relatedCommentList",serverresponse);
                temResult=serverresponse;
                // Added for paginaition
                component.set("v.totalSize", component.get("v.relatedCommentList").length);
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                if(temResult.length>pageSize){
                    for(var i=0; i< pageSize; i++){
                        paginationList.push(temResult[i]);
                    }
                }
                else{
                    for(var i=0; i< temResult.length; i++){
                        paginationList.push(temResult[i]);
                    } 
                }
                component.set('v.paginationList', paginationList);
                
            }else{
                
            }
        });
        $A.enqueueAction(action); 
    },
    replyToTweet : function(component) {
        debugger;
        component.set("v.showSpinner",true);
        
        var replyMessage = component.get("v.tweetReply");
        var tweetId  = component.get("v.tweetId");
        var action = component.get("c.sendReplyToTheTweet");
        action.setParams({
            "tweetId" : tweetId ,
            "message" : replyMessage 
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinner",false);
                component.set("v.isModalOpen", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Reply posted to twitter',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },
    openModel : function(component, event, helper) {
        debugger;
        var comment       = event.getSource().get('v.value');
        var commentedBy   = event.getSource().get('v.name');
        var commentId     = event.getSource().get('v.title');
        component.set("v.selectedCommentId",commentId);
        component.set("v.selectedCommentValue",comment);
        component.set("v.selectedCommentRepliedBy",commentedBy);
        component.set("v.isModalOpen",true);
    },
    closeModel : function(component, event, helper) {
        debugger;
        component.set("v.isModalOpen",false);
        component.set("v.showReplies",false);
    },
    postComment : function(component, event, helper) {
        debugger;
        component.set("v.spinner",true);
        var commentId      = component.get("v.selectedCommentId");
        var commentMessage = component.get("v.replyMessage");
        
        var action         = component.get("c.replyToComment");
        action.setParams({
            commentId: commentId,
            commentMessage : commentMessage
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.spinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The comment has been posted successfully!!"
                });
                toastEvent.fire();
                component.set("v.isModalOpen",false);
            }else{
                
            }
        });
        $A.enqueueAction(action); 
    },
    
    viewCommentReplies : function(component, event, helper) {
        debugger;
        component.set("v.spinner",true);
        var comment       = event.getSource().get('v.value');
        var commentedBy   = event.getSource().get('v.name');
        var commentId     = event.getSource().get('v.title');
        component.set("v.selectedCommentId",commentId);
        component.set("v.selectedCommentValue",comment);
        component.set("v.selectedCommentRepliedBy",commentedBy);
        
        var action         = component.get("c.getRepliesDetails");
        action.setParams({
            commentId: commentId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var serverresponse = response.getReturnValue();
                if(serverresponse.length > 0){
                    component.set("v.relatedReplyList",serverresponse);
                    component.set("v.showReplies",true);
                    component.set("v.spinner",false);    
                }else{
                    component.set("v.relatedReplyList",[]);
                    component.set("v.showReplies",true);
                    component.set("v.spinner",false);  
                }
                
            }else{
                
            }
        });
        $A.enqueueAction(action); 
    },
    
    Next:function(component, event, helperr){
        debugger;
        var oppList = component.get("v.relatedCommentList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        if(end+pageSize+1 >oppList.length  ){
            for(var i=end+1; i<oppList.length; i++){
                //if(oppList.length > end){
                    paginationList.push(oppList[i]);
                    counter ++ ; 
                //} 
                component.set("v.isDisableNextBtn",true);
                
            }
            
        }
        else {
            for(var i=end+1; i<end+pageSize+1; i++){
                //if(oppList.length > end){
                    paginationList.push(oppList[i]);
                    counter ++ ; 
               // } 
            }
            
        }
        
        start = start + counter;
        end = end + counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set('v.paginationList', paginationList);
        /*if(oppList.length == end + counter){
            component.set("v.")
        }*/
        
    },
    
    
    
    Previous:function(component, event, helper){
        debugger;
        var oppList = component.get("v.relatedCommentList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                paginationList.push(oppList[i]);
                counter ++;
            }else {
                start++;
            }
            
        }
        start = start - counter;
        end = end - counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set('v.paginationList', paginationList);
        
        
    }, 
})