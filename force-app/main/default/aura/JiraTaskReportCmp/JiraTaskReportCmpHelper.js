({
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
    },
    toggleHelper : function(component,event) {
        var toggleText = component.find("tooltip");
        $A.util.toggleClass(toggleText, "toggle");
    }
    
});