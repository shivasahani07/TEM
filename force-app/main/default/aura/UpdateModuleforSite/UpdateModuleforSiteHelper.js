({
	 saveEdition: function (component, draftValues) {
        var self = this;
        // simulates a call to the server, similar to an apex controller.
        this
            .server
            .updateOpportunities(draftValues)
            .then($A.getCallback(function (response) {
                var state = response.state;

                if (state === "SUCCESS") {
                    var returnValue = response.returnValue;

                    if (Object.keys(returnValue.errors).length > 0) {
                        // the draft values have some errors, setting them will show it on the table
                        component.set('v.errors', returnValue.errors);
                    } else {
                        // Yay! success, initialize everything back
                        component.set('v.errors', []);
                        component.set('v.draftValues', []);
                        self.fetchData(component);
                    }
                } else if (state === "ERROR") {
                    var errors = response.error;
                    console.error(errors);
                }
            }));
    },
})