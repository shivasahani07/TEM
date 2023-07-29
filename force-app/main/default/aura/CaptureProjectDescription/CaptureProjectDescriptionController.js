({
   openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
  
    submitDetails: function(component, event, helper) {
        debugger;
        var tasks = component.get("v.jiraTaskList");
        var index = component.get("v.index");
        var filledDescription =  component.get("v.filledDescription");
        var DesignDescription =  component.get("v.DesignDescription");
        
        tasks[index].Description__c = filledDescription;
        tasks[index].Solution_Details_if_any__c = DesignDescription;
        
        component.set("v.jiraTaskList", tasks);

        component.set("v.isModalOpen", false);
    },
    doInit: function(component) {
        debugger;
        var tasks = component.get("v.jiraTaskList");
        var index = component.get("v.index");
        
        if(tasks[index].Description__c != '' ){
            component.set("v.filledDescription", tasks[index].Description__c);
        }else{
            component.set("v.filledDescription",'');
        }
        
         if(tasks[index].Solution_Details_if_any__c != '' ){
            component.set("v.DesignDescription", tasks[index].Solution_Details_if_any__c);
        }else{
            component.set("v.DesignDescription",'');
        }

    }
})