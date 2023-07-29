({
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        //component.set("v.handleNext", true);
        var a = component.get('c.handleClick');
        $A.enqueueAction(a);
    },
    
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        //component.set("v.handlePrevious", true);
        var a = component.get('c.handleClick');
        $A.enqueueAction(a);  
    },
    
    handleClick : function(component, event, helper) {    
        debugger;
        component.set('v.pageLoadData',false);
        helper.handleClick(component, event, helper);
    },
    
    handleMainData : function(component, event, helper) {    
        debugger;
        component.set('v.pageLoadData',false);
        helper.handleMainData(component, event, helper);
    },
    
    
    handleSort: function(component,event,helper){
        debugger;
        var sortBy = event.getParam("fieldName");
        
        var sortDirection = event.getParam("sortDirection");
        
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        
        helper.sortData(component,sortBy,sortDirection);
    },
    
    
    
    
    init: function (component, event, helper) {
        debugger;
        component.set('v.pageLoadData',true);
        helper.handleClick(component, event, helper);
        
        //Setting the Coloumns
        component.set('v.columns',[
            {label: 'Jira ID', fieldName: 'Name', type: 'text' ,sortable :true , iconName: 'utility:trending'},
            {label: 'Team Member', fieldName: 'Team_Member_Name__c', type: 'text' ,sortable :true ,  iconName: 'utility:people',editable: true},
            {label: 'Project', fieldName: 'Project_Name__c', type: 'text' , sortable :true ,  iconName: 'utility:setup_assistant_guide',editable: true},
            {label: 'Status', fieldName: 'Status__c', type: 'text', iconName: 'utility:target_mode',editable: true, sortable :true ,cellAttributes: {
                class:  {
                    fieldName: 'class'
                }
            }},
            {label: 'Priority', fieldName: 'Priority__c', type: 'text',sortable :true,iconName: 'utility:priority',editable: true},
            {label: 'Efforts', fieldName: 'Estimated_Efforts__c', type: 'text' , sortable :true,iconName: 'utility:type',editable: true},
            {label: 'Timings', fieldName: 'Task_Start_Time__c', type: 'text',iconName: 'utility:holiday_operating_hours',editable: true},
            {label: 'Task Start date', fieldName: 'Task_Start_Date__c', type: 'date' , sortable :true,iconName: 'utility:date_time',editable: true},
            {label: 'Task End date', fieldName: 'Task_End_Date__c', type: 'date' ,sortable :true,iconName: 'utility:date_time',editable: true},
            {label: 'Assigned By', fieldName: 'Assigned_By_Name__c', type: 'text' , sortable :true , iconName: 'utility:questions_and_answers',editable: true},
            {label: 'Detail',type: "button", iconName: 'utility:summarydetail' ,typeAttributes: {
                label: 'View',
                name: 'View',
                title: 'View',
                disabled: false,
                value: 'view',
                iconPosition: 'right'
            }},
            {label: 'Delete',type: "button", iconName: 'utility:delete' ,typeAttributes: {
                
                //name: 'Delete',
                title: 'Delete',
                iconName: 'utility:delete',
                name: 'delete',
                iconClass: 'slds-icon-text-error',
                disabled: false,
                value: 'Delete',
                iconPosition: 'center'
            }},]);},
            viewRecord : function(component, event, helper) {
            debugger;
            var recId = event.getParam('row').Id;
            var actionName = event.getParam('action').name;
            if ( actionName == 'delete' ){
            var action = component.get("c.DeleteTskFromManagerDashboard");
            action.setParams({
            Recid: recId
            });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
            alert('task has been deleted');
            $A.get('e.force:refreshView').fire();     
            }
            });
            $A.enqueueAction(action);
            
            }
            if ( actionName == 'View' ) {
            //alert('Edit');
            var taskData = component.get("v.data");
            for(var i = 0; i< taskData.length; i++){
            if(recId == taskData[i].Id){
            component.set("v.filledDescription",taskData[i].Description__c);
            component.set("v.DesignDescription",taskData[i].Solution_Details_if_any__c);
            component.set("v.isModalOpen",true);
        }
    }} },
 
 
     handleSaveEdition:function (component, event, helper){
    	debugger;
    	var draftValues = event.getParam('draftValues');
		var action = component.get("c.updateJtList");
        action.setParams({
            jtList: draftValues,
        });
      action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                alert('SUCCESS');
              $A.get('e.force:refreshView').fire();  
            }else{
                 alert('else part');
            }
          
        });
        
        $A.enqueueAction(action);
    
    },
        

})