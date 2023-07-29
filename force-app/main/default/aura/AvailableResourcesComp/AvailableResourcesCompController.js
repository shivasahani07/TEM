({
    doInit: function(component, event, helper) {
        var action=  component.get("c.getAvailiableResource"); 
        debugger;
        action.setCallback(this,function(response){
            var state=response.getState();            
            if(state==='SUCCESS'){
                component.set('v.customers',response.getReturnValue());
            }
        });              
        
        $A.enqueueAction(action);
    },
    
    handleClick : function (component, event, helper) {
        debugger;
        var recId = event.currentTarget.dataset.id;
        component.set("v.isModalOpen", true);
        console.log(recId);
        //alert("You clicked: " + event.getSource().get("v.label"));
        // var whichOne =  event.getSource().get("v.label");
        //var whichOne = event.getSource().getLocalId();
        //component.set("v.conId", whichOne);
        var action=  component.get("c.getPRMLIST");
        action.setParams({ conId : recId});
        action.setCallback(this,function(response){
            var state=response.getState();            
            if(state==='SUCCESS'){
                component.set('v.prmList',response.getReturnValue());
            }
        });              
        
        $A.enqueueAction(action);
        
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    closeMainModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.mainModal", false);
    },
})