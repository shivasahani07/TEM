({
    doInit : function(component, event, helper) {
        debugger;
        
        const monthNames = ["January", "February", "March" , "April" , "May" ,"June" , "July" , "August" , "September" , "October" ,"November","December" ];
        
        var today = new Date();
        if(today.getMonth() >= 0 && today.getMonth() < 9){
            var date = today.getFullYear()+'-0'+(today.getMonth()+1)+'-'+today.getDate();    
        }else{
            var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        }
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
        var dateTime = date;
        component.set("v.currentDate", date);
        
        const weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
        
        const d = new Date();
        let day = weekday[d.getDay()];
        component.set("v.currentDay", day);
        
        var today = new Date();
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
        component.set("v.currentTime", time);
        
        component.set("v.dynamicButtonName", 'Create Cards for '+monthNames[today.getMonth()] );
        
        var action = component.get("c.getMappingDetails");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.mappingDetails", result);
                
            }
        });
        $A.enqueueAction(action); 
    },
    
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
    },
    
    getListWithoutCards : function(component, event, helper){
        var findlol=component.get("v.isModalOpen");
        if(findlol== true){
            component.set("v.isModalOpenSecond", true);
            component.set("v.isModalOpen", false);
        }
        
        debugger;
        var action = component.get("c.getunCaededPRMS");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.length < component.get("v.pageSize") || result.length == 0){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", result.length);
                component.set("v.PRMlist", result);
            }
        });
        $A.enqueueAction(action);
    },
    
    updatePRMData : function(component, event, helper){
        debugger;
        var action = component.get("c.updateCheckBox");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Info',
                    message: 'Mappings have been Updated.Proceed after 30 seconds.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'info',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.isDisbaled", false);
                    }), 10000
                );
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
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
    
    runBtach : function(component, event, helper){
        debugger;
        var action = component.get("c.batchMethod");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
            } 
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
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
    closeModelSecond : function(component, event, helper){
        component.set("v.isModalOpenSecond", false);
        
    },
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getAccounts(component, helper);
    },
    
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getAccounts(component, helper);
    },
    
    handleDeleteAccount: function (component, event, helper) {
        alert('Selected Account to delete - ' + event.getSource().get("v.name"));
    },
})