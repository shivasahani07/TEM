public class TriggerOnHolidayHelper {
    public static void ValidateHolidays(List<Holiday__c> newHolidays) {
        System.debug('newHolidays::' + newHolidays);
        List<Id> contactIds = new List<Id>();
        
        for (Holiday__c hd : newHolidays) {
            if (hd.Contact__c != null) {
                contactIds.add(hd.Contact__c);
            }
        }
        
        System.debug('contactIds::' + contactIds);
        
        List<Holidays__mdt> holi = [SELECT Id, DeveloperName, MasterLabel, Type__c, Max_Allowed__c FROM Holidays__mdt];
        System.debug('holi::' + holi);
        
        Map<Id, Integer> contactHolidaysCount = new Map<Id, Integer>();
        List<Contact> contactsWithHolidays = [
            SELECT Id, Name, (
                SELECT Id, Type__c, Reason__c, Start_Date__c, End_Date__c
                FROM Holidays__r
                WHERE Type__c = 'Sick Leave'
            )
            FROM Contact
            WHERE Id IN :contactIds
        ];
        
        for (Contact con : contactsWithHolidays) {
            //list<Holiday__c> Holiist =con.Holidays__r;
            Integer totalNumberOfTakenHolidays = con.Holidays__r.size();
            contactHolidaysCount.put(con.Id, totalNumberOfTakenHolidays);
            system.debug('contactHolidaysCount'+contactHolidaysCount);
            
            
            for (Holidays__mdt hmdt : holi) {
                system.debug('hmdt'+hmdt);
                System.debug('hmdt.MasterLabel'+hmdt.MasterLabel);
                if (hmdt.MasterLabel == 'Sick Leave') {
                    system.debug('Inside Sick leave');
                    if(hmdt.Max_Allowed__c <totalNumberOfTakenHolidays){
                        newHolidays[0].addError('You hVE leardy taken 👍👍👍!');
                    }
                    
                }
            }
        }
    }
    
    //create bydefualt some hoidays whenever new contact will be created shall addthis from custom setting..? bhaiya
    Public Static void CommonHolidays(List<Contact> newContacts){
        system.debug('newContacts--'+newContacts);
        list<Holiday__c> commonHilidaysLIst= new list<Holiday__c>();
        List<Default_Holidays__mdt	> holidays = [SELECT Id, DeveloperName, MasterLabel,Date__c FROM Default_Holidays__mdt];
        for(contact con:newContacts){
            for(Default_Holidays__mdt hlmd :holidays){
                Holiday__c holidayRec = new Holiday__c ();
                holidayRec.Holiday_Name__c=hlmd.MasterLabel;
                holidayRec.Start_Date__c=hlmd.Date__c;
                holidayRec.End_Date__c=hlmd.Date__c;
                holidayRec.Contact__c=con.Id;
                commonHilidaysLIst.add(holidayRec);
                
            }
        }  
        
        if(!commonHilidaysLIst.isEmpty()){
            insert commonHilidaysLIst;
        }
    }
    
    
}