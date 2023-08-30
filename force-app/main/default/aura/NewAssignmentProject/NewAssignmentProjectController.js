({
    doInit : function(component, event, helper) {
        debugger;
        var today = new Date();
        var DateValue = component.get("v.taskDate");
        
        if(today.getMonth() >= 0 && today.getMonth() < 10){
            if(today.getDate() < 10){
                var date = today.getFullYear()+'-0'+(today.getMonth()+1)+'-0'+today.getDate();
            }else{
                var date = today.getFullYear()+'-0'+(today.getMonth()+1)+'-'+today.getDate();    
            }
        }else{
            if(today.getDate() < 10){
                var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-0'+today.getDate();
            }else{
                var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();    
            }
            //var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-0'+today.getDate();
        }
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
        var dateTime = date+'T11:00:00Z' ;
        
        helper.fetchPickListVal(component, 'Priority__c', 'jiraPriority');
        var jiraTaskRecList = component.get("v.jiraTaskList")
        var assigneeId = component.get("v.assigneeId");
        var action = component.get("c.fetchJiraTasks");
        action.setParams({
            assigneeId: assigneeId,
            DateValue : DateValue
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var serverresponse = response.getReturnValue();
                if(serverresponse.length > 0){
                    component.set("v.jiraTaskList", serverresponse); 
                }else{
                    jiraTaskRecList.push({
                        'sobjectType': 'Jira_Task__c',
                        'Module__c': '',
                        'Description__c': '',
                        'Solution_Details_if_any__c': '',
                        'Priority__c': '',
                        'Task_End_Date_Time__c':dateTime,
                        'Team_Member__c': '',
                        'Task_Start_Date_Time__c':dateTime,
                        'Assigned_By__c':'',
                    });
                    component.set("v.jiraTaskList", jiraTaskRecList);
                }
            }else{
                jiraTaskRecList.push({
                    'sobjectType': 'Jira_Task__c',
                    'Module__c': '',
                    'Description__c': '',
                    'Solution_Details_if_any__c': '',
                    'Priority__c': '',
                    'Task_End_Date_Time__c':dateTime,
                    'Team_Member__c': '',
                    'Task_Start_Date_Time__c':dateTime,
                    'Assigned_By__c':'',
                });
                component.set("v.jiraTaskList", jiraTaskRecList);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleAddRow : function(component, event, helper){
        debugger;
        
        var today = new Date();
        if(today.getMonth() >= 0 && today.getMonth() < 10){
            if(today.getDate() < 10){
                var date = today.getFullYear()+'-0'+(today.getMonth()+1)+'-0'+today.getDate();
            }else{
                var date = today.getFullYear()+'-0'+(today.getMonth()+1)+'-'+today.getDate();    
            }
        }else{
            if(today.getDate() < 10){
                var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-0'+today.getDate();
            }else{
                var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();    
            }
            //var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-0'+today.getDate();
        }
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
        var dateTime = date+'T11:00:00Z' ;
        
        var jiraTaskRecList = component.get("v.jiraTaskList");
        var solnDetails = component.get("v.filledDescription");
        var designDetails = component.get("v.DesignDescription");
        
        jiraTaskRecList.push({
            'sobjectType': 'Jira_Task__c',
            'Module__c': '',
            'Description__c': '',
            'Solution_Details_if_any__c': '',
            'Priority__c': '',
            'Task_End_Date_Time__c':dateTime,
            'Team_Member__c': '',
            'Task_Start_Date_Time__c':dateTime,
            'Assigned_By__c':'',
        });
        component.set("v.jiraTaskList", jiraTaskRecList);
    },
    
    editRecord : function(component, event, helper){
        debugger;
        var selId = event.getSource().get("v.name");
        var jiraTaskRecList = component.get("v.jiraTaskList");
        for (let i = 0; i < jiraTaskRecList.length; i++) {
            if(jiraTaskRecList[i].Id == selId){
                jiraTaskRecList[i].editableTrue = true;
            }
        }

        var solnDetails = component.get("v.filledDescription");
        var designDetails = component.get("v.DesignDescription");
        component.set("v.jiraTaskList", jiraTaskRecList);
    },
    
    removeRecord : function(component, event, helper){
        //  alert("Remove Record");
        // getting the jiraTaskList
        var jiraTaskRecList = component.get("v.jiraTaskList");
        // getting the target object
        var selectedItem = event.currentTarget;
        // getting the selected item index
        var index = selectedItem.dataset.record;
        // remove single record from account List
        jiraTaskRecList.splice(index, 1);
        // set modified account list
        component.set("v.jiraTaskList", jiraTaskRecList);
    },
    
    handleClick : function(component, event, helper) {
        debugger;
        var searchProj = component.get('v.ProjectId');
        var searchLead = component.get('v.ProjectLeadId');
        var searchTeamMate = component.get('v.TeamMateId');
        var searchStartDate = component.get('v.StartDate');
        var searchEndDate = component.get('v.EndDate');
        var action = component.get("c.getTaskDetails");
        action.setParams({
            projectid: searchProj,
            teamLeadId: searchLead,
            employee: searchTeamMate,
            StartDate: searchStartDate,
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
    
    onPicklistChange : function(component, event, helper){
        debugger;
        alert("Onchange",component.get("v.options"))
    },
    
    uploadFile : function(component, event, helper){
        debugger;
        component.set("v.uploadFile",true);
        
    },
    
    showModel : function(component, event, helper){
        debugger;
        var idx = event.target.id;
        component.set("v.index",idx);
        component.set("v.isModalOpen",true);
    },
    
    handleCompanyOnChange : function(component, event, helper) {
        debugger;
        var industry = component.get("v.acc.Priority__c");
        alert(industry);
    },
    
    saveRecord : function(component, event, helper) {
        debugger;
        
        component.set("v.showSpinner", true);
        var jiraTaskRecList = component.get("v.jiraTaskList");
        var jiraTasksTobeUpdated = [];
        
        var assigneeId = component.get("v.assigneeId");
        for (let i = 0; i < jiraTaskRecList.length; i++) {
            //DATE TIME VALIDATION FOR TASK CREATION
            if(jiraTaskRecList[i].Task_Start_Date_Time__c > jiraTaskRecList[i].Task_End_Date_Time__c ){
                alert("End time cannot be eariler then start time. Check row number : "+(i+1));
                component.set("v.showSpinner", false);
                return;
            }
            //Module
            jiraTaskRecList[i].Estimated_Start_Date__c = new Date();
            if(jiraTaskRecList[i].Module__c != undefined && jiraTaskRecList[i].Module__c != null && jiraTaskRecList[i].Module__c != ''){
                jiraTaskRecList[i].Module__c = jiraTaskRecList[i].Module__c[0].Id;     
            }
            //Team Member
            if(jiraTaskRecList[i].Team_Member__c != undefined && jiraTaskRecList[i].Team_Member__c != null  && jiraTaskRecList[i].Team_Member__c != ''){
                jiraTaskRecList[i].Team_Member__c = jiraTaskRecList[i].Team_Member__c.Id;     
            }
            // Assigned By
            jiraTaskRecList[i].Assigned_By__c = assigneeId;
            
            if(jiraTaskRecList[i].editableTrue == true){
                jiraTasksTobeUpdated.push(jiraTaskRecList[i]);
            }
        }
        
        var solnDetails = component.get("v.filledDescription");
        var designDetails = component.get("v.DesignDescription");
        var projectIdForJS = component.get("v.ProjectId");
        var projectLeadIDForJS = component.get("v.ProjectLeadId");
        var projectTeamMateIDForJS = component.get("v.TeamMateId");
        
        var action = component.get("c.SaveRecordJira");
        action.setParams({
            "ProjectId" :  projectIdForJS,
            "TeamLeadId" : projectLeadIDForJS,
            "TeamMateId"  : projectTeamMateIDForJS,
            "jiraTaskListRec" : jiraTaskRecList,
            "updatedjiraTaskList" : jiraTasksTobeUpdated
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.jiraTaskList", response.getReturnValue());
                component.set("v.showSpinner", false);
                helper.successAlert(component , event , 'Task Created Successfully!!😊');
                
            }else{
                component.set("v.showSpinner", false);
                helper.errorAlert(component , event , response.getError()[0].pageErrors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
})