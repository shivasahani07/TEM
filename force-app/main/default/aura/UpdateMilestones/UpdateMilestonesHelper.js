({
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