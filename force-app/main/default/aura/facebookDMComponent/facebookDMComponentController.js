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
            var paginationList = [];
            var temResult=[];
            var state = response.getState();
            var serverresponse = response.getReturnValue();
            if (state === 'SUCCESS' && serverresponse) {
                component.set("v.tweetDescription",serverresponse.description);
                component.set("v.recepientid", serverresponse.recepientId);
                /* component.set("v.filteredCommentList", serverresponse); */
                component.set("v.relatedCommentList",serverresponse.commentWrapperList);
                component.set("v.rawList",serverresponse.commentWrapperList);
                temResult=serverresponse.commentWrapperList;
                /* component.set("v.totalPages", Math.ceil(response.getReturnValue().length / component.get("v.pageSize"))); */
                component.set("v.totalSize", component.get("v.relatedCommentList").length);
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                if(temResult>pageSize){
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

    handleSearch: function(component, event, helper) {
        debugger;
        var searchKeyword = event.currentTarget.value;
        //var searchKeyword = component.get("v.searchKeyword");
        if(searchKeyword && searchKeyword.length < 2)
            return;

        var data = component.get("v.rawList");
        searchKeyword = searchKeyword.toLowerCase();
        var filteredData = data.filter(item => {
            debugger;
            const { comment, CommentedBy } = item;
            const lowerCaseName = comment ? comment.toLowerCase() : '';
            const lowerCaseBy = CommentedBy ? CommentedBy.toLowerCase() : '';
            // Debugging statement
            //console.log("Item Name:", lowerCaseName);
            return lowerCaseName.includes(searchKeyword) || lowerCaseBy.includes(searchKeyword);
        });
        //var filteredData = data.filter(item => item.comment.toLowerCase().includes(searchKeyword.toLowerCase()));
        component.set("v.relatedCommentList", filteredData);
    },
    
    /* changePage: function(component, event, helper) {
        var page = event.currentTarget.dataset.page;
        component.set("v.currentPage", page);
    }, */

    openModel : function(component, event, helper) {
        debugger;
        var comment       = event.getSource().get('v.value');
        var commentedBy   = event.getSource().get('v.name');
        var commentId     = event.getSource().get('v.title');
        var parentId      = event.getSource().get('v.variant');
        
        component.set("v.parentCommentId",parentId);
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
        var recId      = component.get("v.recepientid");
        var commentMessage = component.get("v.replyMessage");
        var parentSFID     = component.get("v.parentCommentId");
        var action         = component.get("c.sendMessage");

        action.setParams({
            recipientId: recId,
            messageText : commentMessage,
            caseId : component.get("v.recordId"),
            parentCommentId: parentSFID,
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Message sent successfully!!"
                });
                toastEvent.fire();
                component.set("v.replyMessage","");
                component.set("v.isModalOpen",false);
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Something went wrong!"
                });
                toastEvent.fire();
            }
            component.set("v.spinner",false);
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
        for(var i=end+1; i<end+pageSize+1; i++){
            if(oppList.length > end){
                paginationList.push(oppList[i]);
                counter ++ ; 
            } 
        }
        start = start + counter;
        end = end + counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set('v.paginationList', paginationList);
        
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