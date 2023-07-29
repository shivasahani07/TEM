({
	/*handleUnitTypeChange : function(component, event, helper) {
        debugger;
        var proname = component.get("v.projectId")
        var actionOne = component.get("c.getModule");  
        debugger;
         actionOne.setParams({  
         "ProjectId" : proname
         });
        actionOne.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var custs = [];
                var conts = response.getReturnValue();
                for(var key in conts){
                    custs.push({value:conts[key], key:key});
                }
                component.set("v.AllModule", custs);
                
            } 
        });           
        $A.enqueueAction(actionOne);
        	},*/
    
    CreateModule : function(component,event,helper){
        debugger;
       var action = component.get("c.createJiraTask");
         action.setParams({
            "taskRec": component.get('v.JiraTaskList')
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //No need to worry below code.
                //This is the stadard code for toast message.
 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record Created successfully."
                });
                toastEvent.fire();   
                 
            }
        });
        $A.enqueueAction(action);
    }
})