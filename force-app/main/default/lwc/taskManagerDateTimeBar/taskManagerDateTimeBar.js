import { LightningElement,track,api} from 'lwc';

export default class TaskManagerDateTimeBar extends LightningElement {

    @track selectedMonth;
    @track selectedYear;

    @track selectedDate;
    @track disablePrev;
    @track disableNext;
    @track numberOfDatesToBeShown = 7;

    @track dateList = [];

    monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

    connectedCallback(){
        this.prepareTimeSlots();
    }

    handlePrevClicked(){
        this.prepareTimeSlots('prev');
    }

    handleNextClicked(){
        this.prepareTimeSlots('next');
    }

    @track todayDate = new Date();
    prepareTimeSlots(action){
        debugger;

        if(this.dateList.length>0){
            if(action=='next'){
                this.todayDate = new Date(this.dateList[this.numberOfDatesToBeShown-1].d);
            }else{
                this.todayDate = new Date(this.dateList[0].d);
            }
            this.dateList = [];
        }

        if(action=='next' || !action){
            for(let i=0;i<this.numberOfDatesToBeShown;i++){
                if(i==0 && !action){
                    this.todayDate.setDate(this.todayDate.getDate());
                }else{
                    this.todayDate.setDate(this.todayDate.getDate()+1);
                }
                var obj = {"day":this.days[this.todayDate.getDay()].substring(0,3),"date":this.todayDate.getDate(),"month_number":this.todayDate.getMonth()+1,"month":this.monthNames[this.todayDate.getMonth()],"selected":i===0,fDate:`${this.todayDate.getDate()}/${this.todayDate.getMonth()+1}/${this.todayDate.getFullYear()}`,d:`${this.todayDate.getFullYear()}-${this.todayDate.getMonth()+1}-${this.todayDate.getDate()}`,year:this.todayDate.getFullYear()};
                this.dateList.push(obj);
            }
        }else if(action=='prev'){
            for(let i=0;i<this.numberOfDatesToBeShown;i++){
                this.todayDate.setDate(this.todayDate.getDate()-1);
                var obj = {"day":this.days[this.todayDate.getDay()].substring(0,3),"date":this.todayDate.getDate(),"month_number":this.todayDate.getMonth()+1,"month":this.monthNames[this.todayDate.getMonth()],"selected":i==this.numberOfDatesToBeShown-1,fDate:`${this.todayDate.getDate()}/${this.todayDate.getMonth()+1}/${this.todayDate.getFullYear()}`,d:`${this.todayDate.getFullYear()}-${this.todayDate.getMonth()+1}-${this.todayDate.getDate()}`,year:this.todayDate.getFullYear()};
                this.dateList.push(obj);
            }
            this.dateList.reverse();
        }

        console.log('DateList---',this.dateList);
        this.selectedDate = this.dateList[0].fDate;
        
        this.selectedMonth = this.dateList[0].month.substring(0,3);
        this.selectedYear = this.dateList[0].year;
        this.callParentMethod();
    }

    ondatechoosedhandler(event){
        debugger;
        this.selectedDate = event.target ? event.target.dataset.id:event;

        let prevSelectedIndex = this.dateList.findIndex(item=>item.selected==true);
        let selectedIndex = this.dateList.findIndex(item=>item.fDate==this.selectedDate);

        this.dateList[prevSelectedIndex].selected = false;
        this.dateList[selectedIndex].selected = true;

        this.selectedMonth = this.dateList[selectedIndex].month.substring(0,3);
        this.selectedYear = this.dateList[selectedIndex].year;

        console.log('SelectedDate---',this.selectedDate);
        this.callParentMethod();
    }

    callParentMethod(){
        let event = new CustomEvent('dateselected',{detail:{date:this.selectedDate}});
        this.dispatchEvent(event);
    }
}