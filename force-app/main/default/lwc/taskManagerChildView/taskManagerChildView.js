import { LightningElement,track,api,wire} from 'lwc';
import getAllTaskRelatedToContact from "@salesforce/apex/TaskManagerChildViewLWCController.getAllTaskRelatedToContact";
import markStatusAsComplete from "@salesforce/apex/TaskManagerChildViewLWCController.markStatusAsComplete";
import sJob from "@salesforce/apex/TaskManagerChildViewLWCController.startJob";
import endJob from "@salesforce/apex/TaskManagerChildViewLWCController.endJob";
import manualTimeEntry from "@salesforce/apex/TaskManagerChildViewLWCController.manualTimeEntry";
import breakStartEnd from "@salesforce/apex/TaskManagerChildViewLWCController.breakStartEnd";
import updateExtension from "@salesforce/apex/TaskManagerChildViewLWCController.updateExtension";
import getFiles from "@salesforce/apex/TaskManagerChildViewLWCController.getFiles";
import getDependencies from "@salesforce/apex/TaskManagerChildViewLWCController.getDependencies";
import createDependencies from "@salesforce/apex/TaskManagerChildViewLWCController.createDependencies";
import getTeamLeads from "@salesforce/apex/TaskManagerChildViewLWCController.getTeamLeads";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';


const fileCol = [
    { label: 'Name', fieldName: 'Name',type:'url'},
];

export default class TaskManagerChildView extends LightningElement {
    @api conId;

    @api selectedDate;
    @api selectedMonth;
    @api selectedYear;
    @track selectedJiraTask;
    @track timeIntervalInstance;
    @track currentTimer = '00h:00m:00s';

    fileCol = fileCol;


    @track extensionDetail = {
        extensionTime:0,
        extensionDescription:''
    }

    @track wiredResponse;
    @track tasks = [];
    @track files = [];
    @track teamLeads = [];

    @track dependency = {
        Name:'',
        Depends_on__c:'',
        Description__c:'',
        Jira_Task__c:'',
    }

    @track dependencies = [];
    @track isLoading = true;
    @track showTasks = false;
    @track showMTEPopup = false;
    @track showExtensionPopup = false;
    @track showDependencyPopup = false;
    @track selectedManualTime = 0;
    @track totalMilliseconds = 0;
    @track showFilesTab;

    @wire(getAllTaskRelatedToContact,{conId:'$conId',selectedDate:'$selectedDate',selectedMonth:'$selectedMonth',selectedYear:'$selectedYear'})
    wiredResult(result){
        console.log('Child View Result---',result);
        console.log('SELECTEDMONTH--',this.selectedMonth);
        console.log('SELECTEDDATE--',this.selectedDate);
        console.log('SELECTEDYEAR--',this.selectedYear);

        this.isLoading = false;
        this.wiredResponse = result;
        this.clearCache();

        if(result.data){
            debugger;
            result.data.forEach((item,index)=>{
                let obj = {...item};
                obj.disableStartBreak =  obj.Status__c=='Dev Completed' || !obj.Actual_Task_Start_Time__c || obj.Status__c=='New'
                obj.disableEndBreak = !obj.Break_Start_Time__c || !obj.Actual_Task_Start_Time__c || (obj.Total_Break_Time__c && obj.Total_Break_Time__c>0);
                obj.startTimeStyle = obj.Status__c == 'In Progress' ? 'success':'brand';
                obj.disableStartTime  = obj.Actual_Task_Start_Time__c || obj.Status__c=='Dev Completed';
                obj.endDisableStartTime = obj.Status__c=='Dev Completed' || (obj.Break_Start_Time__c && !obj.Break_End_Time__c) || obj.Actual_Task_End_Time__c!=null || !obj.Actual_Task_Start_Time__c;
                obj.disableManualTimeEntry = obj.Status__c == 'Dev Completed' || (obj.Break_Start_Time__c && !obj.Break_End_Time__c);
                obj.disableAskForExtension = obj.Status__c == 'Dev Completed' || (obj.Break_Start_Time__c && !obj.Break_End_Time__c);
                obj.estimatedHrs = 'Estimated Hours: '+obj.Estimated_Efforts__c + 'hrs';
                if(obj.Actual_Task_Start_Time__c && !obj.Actual_Task_End_Time__c){
                    debugger;
                    console.log('obj.Actual_Task_Start_Time__c',obj.Actual_Task_Start_Time__c);

                    let cTime = new Date();
                    let istTime = new Date(obj.Actual_Task_Start_Time__c);

                    let diffTime = 0;

                    if(obj.Break_Start_Time__c && !obj.Break_End_Time__c){
                        let bStartTime = new Date(obj.Break_Start_Time__c);

                        let diffBtwStartTimeAndBreakStartTime = bStartTime.getTime() - istTime.getTime();
                        diffTime = diffBtwStartTimeAndBreakStartTime;

                    }else if(obj.Break_Start_Time__c && obj.Break_End_Time__c){
                        let bStartTime = new Date(obj.Break_Start_Time__c);
                        let bEndTime = new Date(obj.Break_End_Time__c);

                        diffTime = cTime.getTime() - istTime.getTime() - (bEndTime.getTime() - bStartTime.getTime());
                    }else{
                        diffTime = cTime.getTime() - istTime.getTime();   
                    }
                    
                    obj.longStartTime = diffTime;
                }else if(obj.Actual_Task_Start_Time__c && obj.Actual_Task_End_Time__c){

                    let starTime = new Date(obj.Actual_Task_Start_Time__c);
                    let endTime = new Date(obj.Actual_Task_End_Time__c);
                    let diffTime = 0;

                    if(obj.Break_Start_Time__c && obj.Break_End_Time__c){
                        let bStartTime = new Date(obj.Break_Start_Time__c);
                        let bEndTime = new Date(obj.Break_End_Time__c);

                        diffTime = ((endTime.getTime() - (bEndTime.getTime() - bStartTime.getTime())) - starTime.getTime());
                    }else{
                        diffTime = endTime.getTime() - starTime.getTime();
                    }
                    obj.longStartTime = diffTime;
                }

              
                debugger;
                if(this.selectedJiraTask){
                    obj.selected = this.selectedJiraTask.Id==obj.Id; 
                }else{
                    obj.selected = index==0;
                }
                obj.disableMarkAsCompleted = obj.Status__c=='Dev Completed' || (obj.Break_Start_Time__c && !obj.Break_End_Time__c) || !obj.Actual_Task_End_Time__c;

                console.log('longStartTime',obj);
                this.tasks.push(obj);
            })
            
            this.showTasks = this.tasks.length>0;
            this.selectedJiraTask = this.tasks.find(item=>item.selected);
            if(!this.selectedJiraTask && this.tasks.length>0 ){
                debugger;
                this.tasks[0].selected = true;
                this.selectedJiraTask = this.tasks[0];
            }

            if(this.selectedJiraTask){

                if(this.selectedJiraTask.Actual_Task_Start_Time__c){
                    debugger;
                    if((this.selectedJiraTask.Break_Start_Time__c && !this.selectedJiraTask.Break_End_Time__c) || (this.selectedJiraTask.Actual_Task_Start_Time__c && this.selectedJiraTask.Actual_Task_End_Time__c)){
                        this.setPauseTimer(this.selectedJiraTask.longStartTime);
                        this.stopTimer();
                    }else {
                        this.configureTimer(this.selectedJiraTask.longStartTime);
                    }
                }else{
                    this.resetTimer();
                }
                this.showFiles();
                this.fetchTeamLeads();
                this.showDependencies();
            }
            
            this.selectedManualTime = 0;
        }
    }

    clearCache(){
        this.tasks = [];
        this.files = [];
        this.dependencies = [];
        this.teamLeads = [];
        this.dependency = {
            Name:'',
            Depends_on__c:'',
            Description__c:'',
            Jira_Task__c:'',
        }
    }


    manualTimeChangeHandler(event){
        this.selectedManualTime = event.target.value;
    }

    taskClicked(event){
        debugger;
        let jiraTaskId = event.currentTarget.dataset.id;
        let prevIndex = this.tasks.findIndex(item=>item.selected);
        this.tasks[prevIndex].selected = false;

        let selectedIndex = this.tasks.findIndex(item=>item.Id==jiraTaskId);
        this.tasks[selectedIndex].selected = true;
        this.selectedJiraTask = this.tasks[selectedIndex];


        if(this.selectedJiraTask.longStartTime){

            let cTime = new Date();
            let istTime = new Date(this.selectedJiraTask.Actual_Task_Start_Time__c);

            let diffTime = 0;
            if(this.selectedJiraTask.Break_Start_Time__c && !this.selectedJiraTask.Break_End_Time__c){
                let bStartTime = new Date(this.selectedJiraTask.Break_Start_Time__c);

                let diffBtwStartTimeAndBreakStartTime = bStartTime.getTime() - istTime.getTime();
                diffTime = diffBtwStartTimeAndBreakStartTime;

            }else if(this.selectedJiraTask.Break_Start_Time__c && this.selectedJiraTask.Break_End_Time__c){
                let bStartTime = new Date(this.selectedJiraTask.Break_Start_Time__c);
                let bEndTime = new Date(this.selectedJiraTask.Break_End_Time__c);

                diffTime = cTime.getTime() - istTime.getTime() - (bEndTime.getTime() - bStartTime.getTime());
            }else{
                diffTime = cTime.getTime() - istTime.getTime();   
            }
                    
            this.selectedJiraTask.longStartTime = diffTime;
            if(!this.selectedJiraTask.Actual_Task_Start_Time__c){
                this.resetTimer();
            }else if((this.selectedJiraTask.Break_Start_Time__c && !this.selectedJiraTask.Break_End_Time__c) || (this.selectedJiraTask.Actual_Task_Start_Time__c && this.selectedJiraTask.Actual_Task_End_Time__c)){
                this.setPauseTimer(this.selectedJiraTask.longStartTime);
                this.stopTimer();
            }else {
                this.configureTimer(this.selectedJiraTask.longStartTime);
            }
        }else{
            this.resetTimer();
        }

        this.files = [];
    }

    resetTimer(){
        this.currentTimer = '00h:00m:00s';
        this.totalMilliseconds = 0;
        clearInterval(this.timeIntervalInstance);
    }

    stopTimer(){
        this.totalMilliseconds = 0;
        clearInterval(this.timeIntervalInstance);
    }

    extensionChangeHandler(event){
        let id = event.target.name;
        let value = event.target.value;

        this.extensionDetail[id] = value;
    }

    startJob(){
        debugger;
        this.isLoading = true;
        let params = {taskId:this.selectedJiraTask.Id,conId:this.conId,selectedDate:this.selectedDate,selectedMonth:this.selectedMonth,selectedYear:this.selectedYear,prmId:this.selectedJiraTask.Project_Resource_Mapping__c};
        console.log('Params---',params);

        sJob(params)
        .then(result=>{
            this.isLoading = false;
            console.log('Job Started Result--',result);
            if(result=='Success'){
                this.showNotification('Success','Job Started!','success');
                refreshApex(this.wiredResponse);
            }else{
                this.showNotification('Error',result,'error');
            }
        })
        .catch(error=>{
            console.log(` this  is error from startJob`,error);
        })
    }

    endJob(){
        this.isLoading = true;
        endJob({teliId:this.selectedJiraTask.Time_Entry_Line_Items__r[0].Id,taskId:this.selectedJiraTask.Id}).then(result=>{
            this.isLoading = false;
            if(result=='Success'){
                this.showNotification('Success','Job ended Successfully!','success');
                refreshApex(this.wiredResponse);
            }else{
                this.showNotification('Failed',result,'error');
            }
        })
    }

    markAsComplete(){
        this.isLoading = true;
        markStatusAsComplete({taskId:this.selectedJiraTask.Id}).then(result=>{
            this.isLoading = false;
            console.log('Result---',result);
            if(result=='Success'){
                this.showNotification('Success','Job marked as completed!','success');
                refreshApex(this.wiredResponse);
            }else{
                this.showNotification('Failed',result,'error');
            }
        })
    }

    manualTimeBtnClicked(){
        this.showMTEPopup = true;
    }

    askExtensionBtnClicked(){
        this.showExtensionPopup = true;
    }

    closeAskExtensionBtnClicked(){
        this.showExtensionPopup = false;
    }

    closeManualTimeBtnClicked(){
        this.showMTEPopup = false;
        this.selectedManualTime = 0;
    }

    

    fillManualTimeEntry(){
        if(!this.selectedManualTime || this.selectedManualTime==0){
            this.showNotification('Failed','Please enter time taken by you.','error');
            return;
        }

        this.isLoading = true;
        manualTimeEntry({taskId:this.selectedJiraTask.Id,conId:this.conId,selectedDate:this.selectedDate,selectedMonth:this.selectedMonth,selectedYear:this.selectedYear,usedHours:this.selectedManualTime,prmId:this.selectedJiraTask.Project_Resource_Mapping__c}).then(result=>{
            this.isLoading = false;
            if(result=='Success'){
                this.showMTEPopup = false;
                this.showNotification('Success','Time Updated Sucessfully!','success');
                refreshApex(this.wiredResponse);
            }else{
                this.showNotification('Failed',result,'error');
            }
        })
    }

    updateTimeExtension(){
        console.log('extensionDetail---',this.extensionDetail);
        if(!this.extensionDetail.extensionTime || this.extensionDetail.extensionTime==0){
            this.showNotification('Error','Please fill extension time','error');
            return;
        }

        if(!this.extensionDetail.extensionDescription){
            this.showNotification('Failed','Please fill description','error');
            return;
        }

        this.isLoading = true;

        updateExtension({taskId:this.selectedJiraTask.Id,timeAskedFor:this.extensionDetail.extensionTime,extensionReason:this.extensionDetail.extensionDescription,estimatedHours:this.selectedJiraTask.Estimated_Efforts__c}).then(result=>{
            this.isLoading = false;

            if(result=='Success'){
                this.showNotification('Success','New Extension created for this task','success');
                this.showExtensionPopup = false;
                this.extensionDetail = {extensionTime:0,extensionDescription:''};
                refreshApex(this.wiredResponse);
            }else{
                this.showNotification('Failed',result,'error');
            }
        })

    }

    startBreak(){
        debugger;
        if(this.selectedJiraTask.Total_Break_Time__c && this.selectedJiraTask.Total_Break_Time__c>5){
            this.showNotification('Failed','Oppss, Break time can only be taken at once 😥','error');
            return;
        }
        breakStartEnd({taskId:this.selectedJiraTask.Id,breakType:'startBreak'}).then(result=>{
            if(result=='Success'){
                this.showNotification('Success','Break Time Started','success');
                refreshApex(this.wiredResponse);
            }else{
                this.showNotification('Failed',result,'error');
            }
        });
    }

    endBreak(){
         breakStartEnd({taskId:this.selectedJiraTask.Id,breakType:'endBreak'}).then(result=>{
            if(result=='Success'){
                this.showNotification('Success','Break Time Ended','success');
                refreshApex(this.wiredResponse);
            }else{
                this.showNotification('Failed',result,'error');
            }
        });
    }

    showFiles(){

        this.showFilesTab = true;
        getFiles({taskId:this.selectedJiraTask.Id}).then(result=>{
            if(result){
                console.log('Files---',result);
                this.files = result;
            }
        })
    }

    fetchTeamLeads(){
        getTeamLeads({conId:this.conId}).then(result=>{
            if(result){
                let leads = [];
                result.forEach(con=>{
                    leads.push({label:con.Name,value:con.Id});
                })
                this.teamLeads = leads;
            }
        })
    }
    showDependencies(){
        this.isLoading = true;
        getDependencies({taskId:this.selectedJiraTask.Id}).then(result=>{
            this.isLoading = false;
            this.dependencies = result;
            console.log('Dependencies fetched -- ',result);
        }).catch(error=>{
            this.isLoading = false;
            console.log('Error to fetch dependencies');
            this.showNotification('Error',error,'error');
        })
    }

    redirectFile(event){
        let fileId = event.currentTarget.dataset.id;
        let baseUrl = window.location.origin;
        let fileUrl = `${baseUrl}/servlet/servlet.FileDownload?file=`+fileId;
        //let fileUrl = 'https://sales-production--sales.sandbox.file.force.com/servlet/servlet.FileDownload?file='+fileId;
        window.open(fileUrl, '_blank');
    }

    dependencyInputHandler(event){
        debugger;
        let fName = event.target.name;
        let value = event.target.value;
        this.dependency[fName] = value;
    }

    createDependency(){
        this.showDependencyPopup = true;
    }

    closeDependencyPopup(){
        this.showDependencyPopup = false;
    }

    submitDependency(){
        this.isLoading = true;
        this.dependency.Jira_Task__c = this.selectedJiraTask.Id;

        if(!this.dependency.Name){
            this.showNotification('Failed','Please choose name','error');
            return;
        }
        if(!this.dependency.Depends_on__c){
            this.showNotification('Failed','Please choose dependency on','error');
            return;
        }

        createDependencies({dp:this.dependency}).then(result=>{
            debugger;
            console.log('Dependency created ----',result);
            this.showNotification('Success','Dependency Created Successfully!','success');
            this.isLoading = false;
            this.dependencies.push(result);
            this.closeDependencyPopup();
            this.dependency = {
                Name:'',
                Depends_on__c:'',
                Description__c:'',
                Jira_Task__c:'',
            }
            refreshApex(this.wiredResponse);
        }).catch(error=>{
            console.log('Error to create dependency--',error);
        })
    }


    configureTimer(timeInLong){
        
        var parentThis = this;
        parentThis.totalMilliseconds = timeInLong;
        
        this.timeIntervalInstance = setInterval(function() {

            var hours = parentThis.zeroPadding(Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)));
            var minutes = parentThis.zeroPadding(Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60)) / (1000 * 60)));
            var seconds = parentThis.zeroPadding(Math.floor((parentThis.totalMilliseconds % (1000 * 60)) / 1000));
        
            parentThis.currentTimer = hours + "h:" + minutes + "m:" + seconds+'s';       
            parentThis.totalMilliseconds += 100;
        }, 100); 
    }

    setPauseTimer(timeInLong){
        var parentThis = this;
        parentThis.totalMilliseconds = timeInLong;

        var hours = parentThis.zeroPadding(Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)));
        var minutes = parentThis.zeroPadding(Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60)) / (1000 * 60)));
        var seconds = parentThis.zeroPadding(Math.floor((parentThis.totalMilliseconds % (1000 * 60)) / 1000));
    
        parentThis.currentTimer = hours + "h:" + minutes + "m:" + seconds+'s';       
    }

    zeroPadding(num){
        console.log('NUMBER CHOOSED----',num);
        if(num){
            return num.toString().length==1? `0${num}`:num;
        }
        return '00';
    }


    showNotification(title,message,variant){
        alert(title+' '+message);
        // const evt = new ShowToastEvent({
        //     title: title,
        //     message: message,
        //     variant: variant,
        // });
        // this.dispatchEvent(evt);
    }
    
}