({
    doinit : function(component, event, helper) {
        var actionOne = component.get("c.getProjectName");  
        debugger;
        actionOne.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var custs = [];
                var conts = response.getReturnValue();
               
                for(var key in conts){
                    custs.push({value:conts[key], key:key});
                }
                component.set("v.AllProject", custs);
                 //component.set("v.projectId", custs[5].key);
                
                
            } 
        });           
        $A.enqueueAction(actionOne);
        var actionTwo = component.get("c.getTeamLead");  
        debugger;
        actionTwo.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var custs = [];
                var conts = response.getReturnValue();
                for(var key in conts){
                    custs.push({value:conts[key], key:key});
                }
                component.set("v.AllTeamLead", custs);
                //helper.handleUnitTypeChange(component,event);
                
            } 
        });           
        $A.enqueueAction(actionTwo);
        
        var actionThree = component.get("c.getAllRole");  
        debugger;
        actionThree.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var custs = [];
                var conts = response.getReturnValue();
                for(var key in conts){
                    custs.push({value:conts[key], key:key});
                }
                component.set("v.AllRole", custs);
                
            } 
        });           
        $A.enqueueAction(actionThree);
         
        
         var proname = component.get("v.projectId")
         var actionFour = component.get("c.getModule");  
        debugger;
        actionFour.setParams({  
         "ProjectId" : proname
         });
        
        actionFour.setCallback(this, function(response) {
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
        $A.enqueueAction(actionFour);



    }
    
})