({
    fetchTaskMap : function(component, event, helper) {
        debugger;
        
        component.set("v.showSpinner", true);
        var conId = component.get("v.recordId");
        var action = component.get("c.getTaskListByResources");
        action.setParams({
            conId : conId
        });
        action.setCallback(this, function(response){
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                var contact = [];
                var result = response.getReturnValue();
                for(var key in result){
                    
                    contact.push({key:key , value:result[key]});
                    // Assuming the array is named 'array' and contains the objects as described
                    
                    for (var i = 0; i < result[key].length; i++) {
                        var description = result[key][i].Description;
                    }
                    
                    //console.log(result[key].Description);
                    
                }
                component.set("v.conList",contact);         
                component.set("v.showSpinner", false);
                component.set("v.showComp", true);
            }
        });
        $A.enqueueAction(action);
    },
    
    navigatingToTask : function (component, event, helper) {
        debugger;
        /*var recordid = event.target.getAttribute('data-recid'); 
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordid,
            "slideDevName": "related"
        });
        navEvt.fire();*/
        var TaskName =  event.target.getAttribute('data-recid');
        var Descrption = event.currentTarget.id; 
        component.set("v.jiraTaskName", TaskName);
        component.set("v.filledDescription", Descrption);
        component.set("v.showTaskInfo", true);
    },
    
    refreshBoard : function (component, event, helper) {
        debugger;
        component.set("v.showComp", false);
        component.set("v.showSpinner", true);
        var conId = component.get("v.recordId");
        var action = component.get("c.getTaskListByResources");
        action.setParams({
            conId : conId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var contact = [];
                var result = response.getReturnValue();
                for(var key in result){
                    contact.push({key:key , value:result[key]});
                }
                component.set("v.conList",contact);         
                component.set("v.showSpinner", false);
                helper.successAlert(component , event , 'Task-List Updated!!😊');
                component.set("v.showComp", true);
            }
        });
        $A.enqueueAction(action);
        
    },  
    showTooltip: function(component, event, helper) {
		        
    },
    
    hideTooltip: function(component, event, helper) {
        var tooltipVisible = component.get("v.tooltipVisible");
        if (tooltipVisible) {
            var overlayLib = component.find("overlayLib");
            overlayLib.closePopover();
            component.set("v.tooltipVisible", false);
        }
    }
})