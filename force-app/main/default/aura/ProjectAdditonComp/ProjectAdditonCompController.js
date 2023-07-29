({
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.selectProjectDisplay", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.selectProjectDisplay", false);
    },
    
    submitDetails: function(component, event, helper) {
        debugger;
        var selProject = component.get("v.selectedProject");
        var conId = component.get("v.recordId");
        var action = component.get("c.updateProjects");
        action.setParams({
            projectId : selProject[0].Id,
            ConId : conId
        });
        action.setCallback(this, function(response) {
            console.log();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": response.getReturnValue()
            });
            toastEvent.fire();
            
            component.set("v.selectProjectDisplay", false);
            component.set("v.displayDailyLineItems", true);
        });
        $A.enqueueAction(action);
        //
    },
})