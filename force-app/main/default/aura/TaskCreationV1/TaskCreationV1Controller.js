({
	CreateJiraTask : function(component, event, helper) {
        debugger;
       var jt = component.get("v.JiraTaskList");
        var action = component.get("c.createTask");
        action.setParams({
            taskRec:jt
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
              // helper.saveJiraTask(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    showJiraTask : function(component, event, helper) {
        debugger;
        var action = component.get('c.displayJiraTask');
        action.setCallback(this, function(response) {
           
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set('v.JiraTaskDisplay', response.getReturnValue()); 
                helper.getPriorityPicklist(component, event);
            }
        });
        $A.enqueueAction(action);
      
    },
    handleCompanyOnChange : function(component, event,helper) {
        var Priority = component.get("v.JiraTaskList.Priority__c");
        alert(Priority);
    }
    
})