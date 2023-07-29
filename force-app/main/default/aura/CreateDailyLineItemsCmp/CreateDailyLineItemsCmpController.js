({
    doInit: function(component, event, helper) {
        debugger;
        
        const date = new Date();
        component.set("v.currentDate", date);
        component.set("v.checkSpinner", true);
        var action = component.get("c.getDailyLineItems");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS"){
                var serverResponse = response.getReturnValue();
                component.set("v.lineiItemsList", serverResponse);
                component.set("v.checkSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    addRow: function(component, event) {
        debugger;
        var recordList = component.get("v.lineiItemsList");
        /*if(recordList.length > 0){
            recordList[recordList.length - 1].Project_Resource_Mapping__c = recordList[recordList.length - 1].Project_Resource_Mapping__c[0].Id;
        }*/
        recordList.push({
            'Name': '',
            'Allocated_Hours__c': '',
            'Consumed_Hours__c': '',
            'Is_Completed__c': '',
            'Task_Description__c': '',
            'Time_Entry_Daily_Card__c': '',
            'Project_Resource_Mapping__c':'',
            'Date_Of_Work__c':''
        });
        component.set("v.lineiItemsList", recordList);
    },
    
    removeRow: function(component, event, helper) {
        debugger;
        
        var recordList = component.get("v.lineiItemsList");    
        
        if(recordList.length>1){
            recordList.splice((recordList.length - 1), 1);
            component.set("v.lineiItemsList", recordList);
        }else{
            
        }
        if(idtoDelete != undefined){
            var deleteEvent = component.getEvent("deleteEvent");
            deleteEvent.setParams({"IdsTodelete" : idtoDelete });
            deleteEvent.fire();
        }
    },
    
    SaveDailyLineItemsDetails : function(Component, helper, event){
        debugger;
        var recordList = Component.get("v.lineiItemsList");
        var recId = Component.get("v.recordId");
        var mlStonePercent = 0;
        console.log('mlStonePercent', mlStonePercent);
        var action = Component.get("c.saveDailyLineItems");
        action.setParams({
            'lineiItemsList': recordList,
            'ContactId' : recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Your Line Items have been udpated successfully!!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                component.set("v.displayDailyLineItems", false);
                $A.get('e.force:refreshView').fire();
            }        
            if(state === "ERROR"){
                var errors= response.getError();
                console.log("ERROR: ", errors);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Saving Error',
                    message: errors[0].message,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'sticky'
                });
                toastEvent.fire();
                component.set("v.displayDailyLineItems", false);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.displayDailyLineItems", false);
    },
})