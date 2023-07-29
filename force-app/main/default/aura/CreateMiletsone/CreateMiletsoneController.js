({
    init: function(component, event, helper) {
        debugger;
        var action = component.get("c.getMilestones");
        action.setParams({
            accountId: component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS"){
                var serverResponse = response.getReturnValue();
                component.set("v.milestonesList", serverResponse);
            }
        });
        $A.enqueueAction(action);	
    },
    
    addRow: function(component, event) {
        debugger;
        var recordList = component.get("v.milestonesList");
        recordList.push({
            'Name': '',
            'Tentative_Date_of_Payment__c': '',
            'Milestone_Weightage__c': '',
            'Milestone_Weightage_Rs__c': '',
            'Is_Collected__c': ''
        });
        component.set("v.milestonesList", recordList);
    },
    
    removeRow: function(component, event, helper) {
        debugger;
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var idtoDelete = selectedItem.dataset.index;
        var recordList = component.get("v.milestonesList");    
        
        if(recordList.length>1){
            recordList.splice(index, 1);
            component.set("v.milestonesList", recordList);
        }else{
            /*recordList.push({
                'Name': '',
                'Tentative_Date_of_Payment__c': '',
                'Milestone_Weightage__c': '',
                'Milestone_Weightage_Rs__c': '',
                'Is_Collected__c': ''
            });
            component.set("v.milestonesList", recordList);  */
        }
        if(idtoDelete != undefined){
            var deleteEvent = component.getEvent("deleteEvent");
            deleteEvent.setParams({"IdsTodelete" : idtoDelete });
            deleteEvent.fire();
        }
    },
    
    SaveMilestoneDetails : function(Component, helper, event){
        debugger;
        
        var recordList = Component.get("v.milestonesList");
        var accId = Component.get("v.recordId");
        var mlStonePercent = 0;
        
        for(var i=0; i<recordList.length; i++){
            mlStonePercent = mlStonePercent + parseInt(recordList[i].Milestone_Weightage__c);
        }
        console.log('mlStonePercent', mlStonePercent);
        
        if(mlStonePercent == 100){
            for(var i=0; i<recordList.length; i++){
                recordList[i].Account__c = accId;
            }
            var action = Component.get("c.saveMilestones");
            action.setParams({
                'milestoneList': Component.get("v.milestonesList")
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Milestone Records have been saved successfully',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    $A.get('e.force:refreshView').fire();
                    
                    if (storeResponse.length == 0) {
                        Component.set("v.Message", 'No Result Found...');
                    } else {
                        Component.set("v.Message", '');
                    }
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
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                }
            });
            $A.enqueueAction(action);
        }
        else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: 'Total Milestone percentage should be 100%',
                duration:' 5000',
                key: 'info_alt',
                type: 'warning',
                mode: 'dismissible'
            });
            toastEvent.fire();
            
        }
    },
    
    CloseQuickAction : function(Component, helper, event){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})