({
      activeProj : function (component, event, helper) {
          debugger;
         var action = component.get("c.activeProjcts");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
               component.set('v.activeProjList', response.getReturnValue());
               console.log('activeProjList::'+activeProjList);
            }
        });
        $A.enqueueAction(action);
    },
      inActiveProj : function (component, event, helper) {
           debugger;
         var action = component.get("c.InactiveProjcts");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
               component.set('v.inActiveProjList', response.getReturnValue());
               console.log('inActiveProjList::'+inActiveProjList);
            }
        });
        $A.enqueueAction(action);
    },
        addRow: function(component, event, helper) {
        //get the account List from component  
        var moduleList = component.get("v.activeProjList");
        //Add New Account Record
        moduleList.push({
            'sobjectType': 'Project__c',
            'Module Description': '',
            'Name': '',
            'Total Estimated Efforts': '',
           
            
            
        });
        component.set("v.activeProjList", moduleList);
    },
    
    removeRecord: function(component, event, helper) {
        //Get the account list
        var activeProjList = component.get("v.activeProjList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Remove single record from account list
        activeProjList.splice(index, 1);
        //Set modified account list
        component.set("v.activeProjList", activeProjList);
    },
})