({
    
    CreateAccount : function(component, event, helper) {
        
        var action = component.get('c.createTask');
        action.setParams({
            "taskRec": component.get('v.JiraTaskList')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record Created successfully."
                });
                toastEvent.fire();   
                
            }
        });
        $A.enqueueAction(action);
    },
    displayJiraTask : function(component, event, helper) {
        
        var action = component.get('c.displayJiraTask');
        action.setCallback(this, function(response) {
            se
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set('v.JiraTaskDisplay', response.getReturnValue());               
            }
        });
        $A.enqueueAction(action);
    },
    save: function(component, event, helper) {
        
       debugger;
    }
})