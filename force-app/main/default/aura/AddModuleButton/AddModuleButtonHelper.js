({
    validateAccountRecords: function(component, event) {
        //Validate all account records
        var isValid = true;
        var moduleList = component.get("v.moduleList");
        for (var i = 0; i < moduleList.length; i++) {
            if (moduleList[i].Name == '') {
                isValid = false;
                alert('moduleList Name cannot be blank on '+(i + 1)+' row number');
            }
        }
        return isValid;
    },
    
     presentModule: function(component, event, helper){
        var  recordId= component.get("v.recordId")
        let action = component.get('c.allRelatedModule');
         action.setParams({
                "ProjectID": recordId
            });
        action.setCallback(this, function (response){
            const state = response.getState();
            if (state === "SUCCESS"){
                var modulenameList = [];
                let returnValue = response.getReturnValue();
                component.set("v.moduleList",returnValue);
                
                if(returnValue.length >0){
                    for (var i = 0; i < returnValue.length; i++) {
                        modulenameList.push(returnValue[i].Name);
                    }
                    component.set("v.selectedValue",modulenameList);
                    component.set("v.showAddModule",true);
                }
            }
        });
         $A.enqueueAction(action);
    },
    showToast : function(component, event,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : type,
            message:message,
            duration:' 5000',
            key: 'info_alt',
            type: type,
            mode: 'sticky'
        });
        toastEvent.fire();
    }
})