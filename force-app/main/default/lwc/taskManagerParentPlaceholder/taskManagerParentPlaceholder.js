import { LightningElement,track,api, wire} from 'lwc';


export default class TaskManagerParentPlaceholder extends LightningElement {

    @track selectedDate;
    @track selectedMonth;
    @track selectedYear;
    @api conId='0036D00000UyT7oQAF';

    dateSelectedCallback(callback){
        debugger;
        let parts = callback.detail.date.split('/');

        this.selectedDate = parseInt(parts[0]);
        this.selectedMonth = parseInt(parts[1]);
        this.selectedYear = parseInt(parts[2]);

        console.log('Placeholder recieved---',parts);
    }


}