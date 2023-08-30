({
    handleClick : function(component, event, helper) {
        debugger;
        component.set('v.showRefreshedData',true);
        var pageLoadData = component.get('v.pageLoadData');
        var searchProj = component.get('v.ProjectId');
        var searchLead = component.get('v.ProjectLeadId');
        var searchTeamMate = component.get('v.TeamMateId');
        var searchStartDate = component.get('v.StartDate');
        var conId = component.get('v.recordId');
        var searchEndDate = component.get('v.EndDate');
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var action = component.get("c.getTaskData");
        
        action.setParams({
            projectid: searchProj,
            teamLeadId: searchLead,
            employee: searchTeamMate,
            StartDate: searchStartDate,
            endDate: searchEndDate,
            pageSize : pageSize,
            pageNumber : pageNumber,
            ConId : conId,
            pageLoadData : pageLoadData
        });
        debugger;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resultData = response.getReturnValue();
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", resultData.length);
                
                for (let i = 0; i < resultData.length; i++) {
                    if(resultData[i].Status__c == 'In Progress'){
                        resultData[i].class = 'slds-text-color_error';
                    }else if(resultData[i].Status__c == 'Dev Completed'){
                        resultData[i].class = 'slds-text-color_success';
                    }else{
                        resultData[i].class = 'yellow';
                    }
                }
                //component.set('v.showFooter',true);
                component.set("v.data", resultData);
            }
        });
        
        $A.enqueueAction(action);
    },
    handleMainData : function(component, event, helper) {
        debugger;
        component.set("v.showRefreshedData", false);
        var pageLoadData = component.get('v.pageLoadData');
        var searchProj = component.get('v.ProjectId');
        var searchLead = component.get('v.ProjectLeadId');
        var searchTeamMate = component.get('v.TeamMateId');
        var searchStartDate = component.get('v.StartDate');
        var conId = component.get('v.recordId');
        var searchEndDate = component.get('v.EndDate');
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = '1';//component.get("v.pageNumber").toString();
        var action = component.get("c.getTaskData");
        
        action.setParams({
            projectid: searchProj,
            teamLeadId: searchLead,
            employee: searchTeamMate,
            StartDate: searchStartDate,
            endDate: searchEndDate,
            pageSize : pageSize,
            pageNumber : pageNumber,
            ConId : conId,
            pageLoadData : pageLoadData
        });
        debugger;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var resultData = response.getReturnValue();
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", resultData.length);
                
                for (let i = 0; i < resultData.length; i++) {
                    if(resultData[i].Status__c == 'In Progress'){
                        resultData[i].class = 'slds-text-color_error';
                    }else if(resultData[i].Status__c == 'Dev Completed'){
                        resultData[i].class = 'slds-text-color_success';
                    }else{
                        resultData[i].class = 'yellow';
                    }
                }
                component.set("v.data", resultData);
                component.set("v.showRefreshedData", true);
                
                component.set('v.pageNumber',1);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.data");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        data.sort(function(a,b){
            var a = key(a) ? key(a) : '';
            var b = key(b) ? key(b) : '';
            return reverse * ((a>b) - (b>a));
        });
        component.set("v.data",data);
    }
    
})