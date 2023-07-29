global class HolidayCalenderController {
     @RemoteAction
    global static List<Holiday__c> getEvents() {
        String userId = UserInfo.getUserId();
        userid='0036D00000UyT7oQAF';
        List <Holiday__c> userCalendar = [SELECT Calendar_Event__c,Contact__c,CreatedById,Calendar_Event__r.Name,CreatedDate,End_Date__c,Id,Name,OwnerId,Reason__c,Start_Date__c,Type__c FROM Holiday__c where Contact__c =:userId];
        system.debug('userCalendar++'+userCalendar);
        if(userCalendar.size()>0){
            return userCalendar;
        } else{
            return null; 
        }
    }
    
    
     @RemoteAction
    global static List<Holiday__c> createOrUpdateEvents(String calendarEvent) {
        system.debug('calendarEvent+++'+calendarEvent);
        //system.debug('!!!unixDatetime='+datetime.newinstance(long.valueOf(unixDateTime)));
        //Geting Calendar_Event__c object from received Json String
        Calendar_Event__c eventObject = ((Calendar_Event__c) JSON.deserialize(calendarEvent, Calendar_Event__c.class));
        //you need to put proper regex to validate recordId
        Boolean isOldRecord = eventObject.Id != null;
        upsert eventObject;
        //If its new record, create User Calendar record as well
        if(!isOldRecord){
            Holiday__c userCalendar = new Holiday__c(Calendar_Event__c=eventObject.Id, Contact__c = '0036D00000UyT7oQAF  ' );
            insert userCalendar;
        }
        return getEvents();
    }

}