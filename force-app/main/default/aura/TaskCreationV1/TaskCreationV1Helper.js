({
	 getPriorityPicklist: function(component, event) {
         debugger;
        var action = component.get("c.getPriority");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var priorityMap = [];
                for(var key in result){
                    priorityMap.push({key: key, value: result[key]});
                }
                component.set("v.PriorityMap", priorityMap);
            }
        });
        $A.enqueueAction(action);    
 	}
    /*saveJiraTask: function(component, event) {
        var jt = component.get("v.JiraTaskList");
        var actionOne = component.get("c.createTask");
        actionOne.setParams({
            "taskRec" : jt
        });
        actionOne.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                alert('Record is Created Successfully');
            } else if(state === "ERROR"){
                var errors = actionOne.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
            
        });       
        $A.enqueueAction(actionOne);
    }*/ 
})