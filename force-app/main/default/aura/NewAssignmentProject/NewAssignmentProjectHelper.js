({
    fetchPickListVal : function(component, fieldName, elementId) {
        // alert("Hi")
        debugger;
        var action = component.get("c.getPicklitValueFromSobject");
        action.setParams({
            "objObject" : component.get("v.objInfo"),
            "fieldName" : fieldName
        });
        var optValues = [];
        action.setCallback(this, function(response){
            var State = response.getState();
            var result = response.getReturnValue();
            var industryMap = [];
            for(var key in result){
                industryMap.push({key: key, value: result[key]});
            }
            component.set("v.industryMap", industryMap);
        });
        $A.enqueueAction(action);
    },
    
    errorAlert: function(cmp, event , message) {
        this.LightningAlert.open({
            message: message,
            theme: 'error',
            label: 'Error!!',
        }).then(function() {
            console.log('alert is closed');
        });
    },
    
    successAlert: function(cmp, event , message) {
        this.LightningAlert.open({
            message: message,
            theme: 'success',
            label: 'Success!!',
        }).then(function() {
            console.log('alert is closed');
        });
    },
    
    warningAlert: function(cmp, event , message) {
        this.LightningAlert.open({
            message: message,
            theme: 'warning',
            label: 'Success!!',
        }).then(function() {
            console.log('alert is closed');
        });
    }
})