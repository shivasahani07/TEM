({    
    doInit: function (component, event, helper) {
        debugger;
    },
    
    handleClick:function(component, event, helper){
        debugger;
        var moduleData = [];
        var projectid=component.get("v.ProjectId");
        let action = component.get("c.UpdateMilesstonesfromsite");
        action.setParams({
            "projID": projectid
        });
        action.setCallback(this, function(response) {
            //get response status 
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().length > 0){
                    var response = response.getReturnValue();
                    for (let i = 0; i < response.length; i++) {
                        moduleData.push({
                            'Name' : response[i].Name,
                            'Id':response[i].Id,
                            'Description' : response[i].Module_Description__c,
                            'Actual_Hours' : response[i].Actual_Estimated_Efforts__c,
                            'Aniticipated_Hours' : response[i].Anticipated_Hours__c,
                            'Status' : response[i].Is_Completed__c,
                            'is_Updated' : false,
                            'is_Disabled' : true,
                            'ProjectID':response[i].Project__c,
               				'PRM': response[i].Project_Resource_Mapping__c,
                        });
                    }
                }
                //component.set("v.data", response.getReturnValue());
                component.set("v.data", moduleData);
                component.set("v.truthy",true); 
            }
        }); 
        $A.enqueueAction(action);
    },
    
    viewRecord : function(component, event, helper){
        debugger;
        var recId = event.getParam('row').Id;
        var actionName = event.getParam('action').name;
        if ( actionName == 'Close') {
            alert('Close');
            var projectid=component.get("v.ProjectId");
            let action = component.get("c.UpdateModule");
            action.setParams({
                "Moduleid": recId,
                "Action":actionName
            });
            action.setCallback(this, function(response) {
                //get response status 
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    // window.location.reload()
                    
                }
            }); 
            $A.enqueueAction(action);
            
        } if(actionName == 'Delete'){
            alert('Delete');
            var projectid=component.get("v.ProjectId");
            let action = component.get("c.UpdateModule");
            action.setParams({
                "Moduleid": recId,
                "Action":actionName
            });
            action.setCallback(this, function(response) {
                //get response status 
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    // window.location.reload()
                    
                }
            }); 
            $A.enqueueAction(action);
            
        }
    },
    
    handleCloseAccount: function(component, event, helper){
        debugger;
        var recId = event.getSource().get("v.name");
        alert("You clicked: " + event.getSource().get("v.name"));
        let action = component.get("c.UpdateModuless");
        action.setParams({
            "Moduleid": recId
        });
        action.setCallback(this, function(response) {
            //get response status 
            var state = response.getState();
            if (state === "SUCCESS") {
                
                //window.location.reload()
                
            }
        }); 
        $A.enqueueAction(action);
    },
    handleDeleteAccount: function(component, event, helper){
        debugger;
        var recId = event.getSource().get("v.name");
        var ModuleList =component.get("v.data");
        for(var i=0; i< ModuleList.length(); i++){
            if(ModuleList[i].Id ==recId){
                var AcntipatedValue =ModuleList[i].Anticipated_Hours__c;
                
            }
        }
        alert("You clicked: " + event.getSource().get("v.name"));
        let action = component.get("c.UpdateModules");
        action.setParams({
            "Moduleid": recId
        });
        action.setCallback(this, function(response) {
            //get response status 
            var state = response.getState();
            if (state === "SUCCESS") {
                
                // window.location.reload()
                
            }
        }); 
        $A.enqueueAction(action);
    },
    closeModel : function(component, event, helper){
        debugger;
        component.set("v.isModalOpen",false);
    },
    saveChangesRecord:function(component, event, helper){
        debugger;
        var ModuleListt =component.get("v.data");
        let action = component.get("c.saveModuleLIst");
        var newModuleList=[];
        for(var i=0; i<ModuleListt.length; i++){
            newModuleList.push({
                'Name' : ModuleListt[i].Name,
                'Id':ModuleListt[i].Id,
                'Module_Description__c' : ModuleListt[i].Description,
                'Actual_Estimated_Efforts__c' : ModuleListt[i].Actual_Hours,
                'Anticipated_Hours__c' : ModuleListt[i].Aniticipated_Hours,
                'Is_Completed__c': ModuleListt[i].Status,
                'Project__c':ModuleListt[i].Project__c,
                'Project_Resource_Mapping__c': ModuleListt[i].Project_Resource_Mapping__c,
            });
        }
        action.setParams({
            "mddList": newModuleList
        });
        action.setCallback(this, function(response) {
            //get response status 
            var state = response.getState();
            if (state === "SUCCESS") {
                
                alert('updated succsessfully')
                
            }
        }); 
        $A.enqueueAction(action);
    },
    
    EditableInput:function(component,event,helper){
        debugger;
        var moduleList = component.get("v.data");
        var selId = event.getSource().get("v.name");
        //Get the target object
        //Get the selected item index
        
        for(var i=0; i< moduleList.length; i++){
            if(moduleList[i].Id == selId ){
                if(moduleList[i].is_Disabled = true){
                    moduleList[i].is_Disabled = false;
                }
                else if (moduleList[i].is_Disabled = false){
                    moduleList[i].is_Disabled = true
                }
                
            }
        }
        
        
        //Remove single record from account list
        
        //Set modified account list
        component.set("v.data", moduleList);        
    },
    addRow: function(component, event, helper) {
        debugger; 
        var moduleList = component.get("v.data");
       	var projectID = component.get("v.data[0].ProjectID");
        var PRM = component.get("v.data[0].PRM");
        //Add New Account Record
        moduleList.push({
            //'sobjectType': 'Milestone__c',
            'Name':'',
            'Project_Resource_Mapping__c':PRM,
            'Project__c':projectID,
            'Actual_Estimated_Efforts__c':'',
            'Anticipated_Hours__c':'',
            'Is_Completed__c':'',
            'Module_Start_Date__c':'',
            'Total_Estimated_Effort__c':'',

        });
        
        component.set("v.data", moduleList);
    }
    
  
})