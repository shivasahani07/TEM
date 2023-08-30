({
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        debugger;
        var jiraTaskId=component.get("v.recordId");
        var Description=component.get("v.filledDescription");
        var Design=component.get("v.DesignDescription");
        var action = component.get("c.updateJtDescription");
        action.setParams({
            recordId: jiraTaskId,
            Description: Description,
            Sollution: Design
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                alert('UPDATED..👍');
               component.set("v.isModalOpen", false);

                //$A.get('e.force:refreshView').fire();  
            }else{
                alert('SOME ERROR OCCORED..');
            }
            
        });
        
        $A.enqueueAction(action);
        
    },

})