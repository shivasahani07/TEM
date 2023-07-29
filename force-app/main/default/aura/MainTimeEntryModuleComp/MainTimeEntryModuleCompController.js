({
    doInit : function( component, event, helper ) {
        debugger;
        var recordId = component.get('v.recordId');
        var action = component.get("c.getConDetails");
        action.setParams({
            "ConId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.recordData", response.getReturnValue());
                if(response.getReturnValue().conDetails != null && response.getReturnValue().conDetails != undefined){
                    component.set("v.conDetails", response.getReturnValue().conDetails);
                    if(response.getReturnValue().conDetails.Role__c == 'Team Lead'){
                        component.set("v.ShowResTasks",true);    
                        component.set("v.ShowManDashboard",true);
                        component.set("v.ShowTLDashboard",true);
                        component.set("v.ShowResDashboard",true);
                    }else if(response.getReturnValue().conDetails.Role__c == 'Developer'){
                        component.set("v.ShowResTasks",true);    
                        //component.set("v.ShowManDashboard",true);
                        component.set("v.ShowTLDashboard",true);
                        component.set("v.ShowResDashboard",true);
                    }else if(response.getReturnValue().conDetails.Role__c == 'Project Manager'){
                        component.set("v.ShowResTasks",true);    
                        component.set("v.ShowManDashboard",true);
                        component.set("v.ShowTLDashboard",true);
                        component.set("v.ShowResDashboard",true);
                    }
                }
                var title = 'Welcome '+response.getReturnValue().conDetails.Name + '😊😊';
                component.set("v.titleName", title);
                component.set("v.ShowProgress", true);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    
    showModel : function(component, event, helper){
        debugger;
        component.set("v.isModalOpen",true);
    },
    showUploadComp : function(component, event, helper){
        debugger;
        component.set("v.isUploadOpen",true);
    },
    showCaseComp : function(component, event, helper){
        debugger;
        component.set("v.isCaseOpen",true);
    },
    ShowResource : function(component, event, helper){
        debugger;
        component.set("v.ShowAvaiableResource",true);
    },
    tagTeamMember : function(component, event, helper){
        debugger;
        component.set("v.addMember",true);
    },
    
    showModuleUpdate:function(component, event, helper){
        debugger;
        component.set("v.isModuleUpdateOpen",true);
    },
    
    showHolidayss:function(component, event, helper){
        debugger;
        component.set("v.showHolidays",true);
       
      
    },
    falsecalender :function(component, event, helper){
        debugger;
        let myData = event.getParam('data');
        if(myData === 'Success'){
          component.set("v.showHolidays",false);
        }
       
    }
    
})