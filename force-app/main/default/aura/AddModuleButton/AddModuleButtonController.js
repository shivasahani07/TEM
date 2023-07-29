({
   
    
    doInit: function (component, event, helper) {
        debugger;
        helper.presentModule(component, event);
        let action = component.get('c.addModule');
        
        
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                let returnValue = response.getReturnValue();
                var modulenameList = [];
                for (var i=0; i <returnValue.length; i++) {
                    modulenameList.push({value: returnValue[i].MasterLabel,label: returnValue[i].MasterLabel});
                }
                
                component.set("v.preDefinedmodules", modulenameList);
                component.set("v.options", returnValue);
                
                console.log('modulenameList::'+modulenameList);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showModuleComp: function(component, event, helper) {
        debugger;
        var moduleList = component.get("v.moduleList");
        var selectedValues = component.get("v.selectedmodules");
        var selectedValuesformodules =  moduleList;
        if(selectedValues.length > 0){
            //line no 29  to 37  i have doubt Shubham Bhiaya i need to underStand 
            for (let i = 0; i < selectedValues.length; i++) {
                for( let j = 0; j < moduleList.length; j++){
                    if(moduleList[j].Name == selectedValues[i]){
                        //alert('This module is already Selected!!');
                        helper.showToast(component, event,'This module is already Selected','Warning')
                        return;
                    }
                }
                selectedValuesformodules.push({
                    'Name': selectedValues[i],
                    'Module_Description__c': '',
                    'Total_Estimated_Efforts__c': '',
                    //'Module_Start_Date__c':'',
                    // 'Module_End_Time__c':''
                    
                });
                
            }
            component.set("v.moduleList", selectedValuesformodules);
            component.set("v.showAddModule", true); 
        }else{
            //alert('Please Select the required moduel to proceed!!');
            var toastEvent = $A.get("e.force:showToast");
             helper.showToast(component, event,'Please Select the required moduel to proceed!!','Warning')
           
            return;
        }
    },
    
    handleChange: function (component, event, helper) {
        debugger;
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedmodules", selectedOptionValue);
        
    },
    
    //for Module if box
    addRow: function(component, event, helper) {
        //get the account List from component  
        var moduleList = component.get("v.moduleList");
        //Add New Account Record
        moduleList.push({
            'sobjectType': 'Module__c',
            'Module Description': '',
            'Name': '',
            'Total Estimated Efforts': '',
            
            
        });
        component.set("v.moduleList", moduleList);
    },
    
    removeRecord: function(component, event, helper) {
        //Get the account list
        var moduleList = component.get("v.moduleList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from account list
        moduleList.splice(index, 1);
        //Set modified account list
        component.set("v.moduleList", moduleList);
    },
    
    saveModule: function(component, event, helper) { 
        debugger;
        var  recordId= component.get("v.recordId")
        var ModuleListt = component.get("v.moduleList");
        var addModuleList=[];
        if(ModuleListt.length > 0){
            for (let i = 0; i < ModuleListt.length; i++) {
                ModuleListt[i].Project__c=recordId;
                
            }
            component.set("v.moduleList", ModuleListt);
        }
        
        if (helper.validateAccountRecords(component, event)) {
            //Call Apex method and pass account list as a parameters
            var action = component.get("c.saveModuleLIst");
            action.setParams({
                "mddList": ModuleListt
            });
            action.setCallback(this, function(response) {
                //get response status 
                var state = response.getState();
                if (state === "SUCCESS") {
                    //set empty account list
                    component.set("v.moduleList", response.getReturnValue());
                    helper.showToast(component, event,'This module has been added successfully','success')  
                   //var dismissActionPanel = $A.get("e.force:closeQuickAction");
                   // dismissActionPanel.fire();An
                }
            }); 
            $A.enqueueAction(action);
        }
    },
    
    
})