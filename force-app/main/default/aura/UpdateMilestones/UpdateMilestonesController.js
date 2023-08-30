({
    doInit: function (component, event, helper) {
        debugger;
        var projectId=component.get('v.recordId');
        let action = component.get('c.getMilesstones');
        action.setParams({
            "projectiD": projectId
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                component.set("v.MilestoneList", response.getReturnValue());
                var milestone = component.get("v.MilestoneList")[0];
                var projectName = milestone.Project__r.Name;
                var concatenatedString = `Update Miles stones for ${projectName}`;
                component.set("v.porjectTitlewithName", concatenatedString);
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    updateMilestones:function (component, event, helper){
        debugger;
        var projectId=component.get('v.recordId');
        var milstList=component.get('v.MilestoneList');
        let action = component.get('c.UpdateMilesstones');
        
        if(milstList.length > 0){
            for (let i = 0; i < milstList.length; i++) {
                milstList[i].Project__c=projectId;
                
            }
            component.set("v.MilestoneList", milstList);
        }
        action.setParams({
            "milstoneListTobeUpdate": milstList
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                component.set("v.MilestoneListt", response.getReturnValue());
                component.set("v.MilestoneList", milstList);
                helper.showToast(component, event,'This milestones has been added successfully','success')  
                //alert('milestones update successfully');
                $A.get('e.force:refreshView').fire();
                
            }
            else if (state === "INCOMPLETE") {
                helper.showToast(component, event,'this incomplete check log','warning')  
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        helper.showToast(component, event,'check console occured some error','error')  
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        
    },
    removeRecord: function(component, event, helper) {
        debugger;
        //Get the account list
        var MilestoneList = component.get("v.MilestoneList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from account list
        MilestoneList.splice(index, 1);
        //Set modified account list
        component.set("v.MilestoneList", MilestoneList);
    },
    addRow: function(component, event, helper) {
        debugger; 
        //var AccountId='';
        var MilestoneList = component.get("v.MilestoneList");
        for(let i = 0; i < MilestoneList.length; i++){
            //var AccountId=MilestoneList[0].Account__c;
        }
        var AccountId = component.get("v.MilestoneList[0].Account__c");
        //Add New Account Record
        MilestoneList.push({
            //'sobjectType': 'Milestone__c',
            'Name__c':'',
            'Description__c':'',
            'Expected_Start_Date__c':'',
            'Expected_End_Date__c':'',
            'Account__c':AccountId
            
            
            
        });
        component.set("v.MilestoneList", MilestoneList);
    },
    
    
})