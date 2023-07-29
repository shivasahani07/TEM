({
    doInit : function(component, event, helper) {
        debugger;
    },
    
    currentMonth : function(component, event, helper) {
        debugger;
        var currentdate = new Date(); 
        var action = component.get("c.callingBatchForBulkInvoiceForwarding");
        action.setParams({
            timeValue : currentdate
        });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Email Sent to CA',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                var serverResponse = response.getReturnValue();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            } else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'error',
                    message: response.getState(),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }    
        });
        $A.enqueueAction(action);	
    },
    
    previousMonth : function(component, event, helper) {
        debugger;
        
        var currentdate = new Date(); 
        currentdate.setMonth( currentdate.getMonth() - 1 );
        
        var action = component.get("c.callingBatchForBulkInvoiceForwarding");
        action.setParams({
            timeValue : currentdate
        });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Email Sent to CA',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                var serverResponse = response.getReturnValue();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            } else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'error',
                    message: response.getState(),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }    
        });
        $A.enqueueAction(action);	
    }
})