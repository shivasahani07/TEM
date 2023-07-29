({
	handleClick : function(component, event, helper) {
        debugger;
      var searchProj = component.get('v.ProjectId');
      var searchLead = component.get('v.ProjectLeadId');
       var searchTeamMate = component.get('v.TeamMateId');
        var searchStartDate = component.get('v.StartDate');
        var searchEndDate = component.get('v.EndDate');
      var action = component.get("c.getDetails");
      action.setParams({
          projectid: searchProj,
          contact: searchLead,
          teamLeadId: searchTeamMate,
          startDate: searchStartDate,
          endDate: searchEndDate
      });
        debugger;
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var serverresponse = response.getReturnValue();
                 component.set("v.data", response.getReturnValue());
                 component.set("v.filteredData", response.getReturnValue());
                 component.set("v.ProjectTaskListWrapper", response.getReturnValue());        
         
        }
      });

      $A.enqueueAction(action);
    },
    

	init: function (component, event, helper) {
        component.set('v.columns',[
            {label: 'Jira ID', fieldName: 'JiraId', type: 'List', sortable : true, editable:true},
            {label: 'Team Member', fieldName: 'TeamMember', type: 'List', sortable : true, editable:true},
            {label: 'Project', fieldName: 'Project', type: 'List', sortable : true, editable:true},
            {label: 'Module', fieldName: 'Module', type: 'List', sortable : true, editable:true},
            {label: 'Task Description', fieldName: 'TaskDescription', type: 'text', sortable : true, editable:true},
             {label: 'Status', fieldName: 'Status', type: 'List', sortable : true, editable:true},
           {label: 'Estimated Efforts', fieldName: 'EstimatedEfforts', type: 'text', sortable : true, editable:true},
            {label: 'Actual Efforts', fieldName: 'ActualEfforts', type: 'text', sortable : true, editable:true},
           {label: 'Is Overdue', fieldName: 'IsOverdue', type: 'boolean', sortable : true, editable:true},
        ]);

            
          var action = component.get("c.getDetails");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
                component.set("v.filteredData", response.getReturnValue());
                Component.set("v.data", response.getReturnValue());
            
             
            }
        });
        $A.enqueueAction(action);
    },
})