trigger TriggerOnHoliday on Holiday__c (before insert) {
    if (trigger.IsInsert &&Trigger.IsBefore){
        TriggerOnHolidayHelper.ValidateHolidays(Trigger.new);
     }
}