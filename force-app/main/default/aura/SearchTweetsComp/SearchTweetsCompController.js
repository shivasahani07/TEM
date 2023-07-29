({
    myAction : function(component, event, helper) {
        debugger;
        var searchValue = component.get("v.searchValue");
        var action = component.get("c.searchTweets");
        action.setParams({ "searchValue" : searchValue });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.relatedTweetList", result);
            } 
            else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    replyToTweet : function(component) {
        debugger;
        var replyMessage = component.get("v.replyMessage");
        var tweetId  = component.get("v.tweetId");
        var action = component.get("c.sendReplyToTheTweet");
        action.setParams({
            "tweetId" : tweetId ,
            "message" : replyMessage 
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isModalOpen", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Your message has been posted successfully!!"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    openModel: function(component, event, helper) {
        debugger;
        var whichOne = event.getSource().get("v.value");
        component.set("v.isModalOpen", true);
        component.set("v.tweetId", whichOne);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
    },
    
})