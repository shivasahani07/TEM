trigger TriggerOnContact on Contact (before insert,after insert) {
    if(Trigger.isinsert && Trigger.isAfter){
        TriggerOnHolidayHelper.CommonHolidays(Trigger.new);
    }
    
}