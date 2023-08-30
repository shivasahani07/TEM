public class MonthlyLineItemsCreation {
    
    @AuraEnabled
    public static void updateCheckBox(){
        List<Project_Resource_Mapping__c> PRMlist = [select id , Card_Created__c from Project_Resource_Mapping__c];
        for(Project_Resource_Mapping__c prm  : PRMlist){
            prm.Card_Created__c = false;
        }
        update PRMlist;
    }
    
    @AuraEnabled
    public static void runBatchForCardCreation(){
        MonthlyCardCreationBatch batchInstance = new MonthlyCardCreationBatch();
        database.executeBatch(batchInstance);
    }
    
    @AuraEnabled
    public static void batchMethod(){
        
        List<Project_Resource_Mapping__c> projectList = [Select id , name,Project__c,Project__r.Name from Project_Resource_Mapping__c ];
        system.debug('projectList'+projectList[0].Id);
        String CurrentMonth = Datetime.now().format('MMMM');
        
        List<Time_Entry_Monthly_Card__c> MonthlyCardList = new List<Time_Entry_Monthly_Card__c>();
        List<Time_Entry_Weekly_Card__c> WeeklyCardList = new List<Time_Entry_Weekly_Card__c>();
        List<Time_Entry_Daily_Card__c> DailyCards = new list<Time_Entry_Daily_Card__c>();
        
        Map<String,String> projectNameByPRMId = new Map<String,String>();
        integer numberOfWeek = 0;
        
        //Logic for how many weeks are Remaining
        Date d = System.today();
        Datetime dt = (DateTime)d;
        String dayOfWeek = dt.format('EEEE'); //This returns - Monday, Tuesday, Wednesday, etc..
        
        //Number of days Remainig..
        //Date startDate = system.today();
        Date startDate = System.today().toStartOfMonth();
        Date firstDayOfMonth = System.today().toStartOfMonth();
        Date endDate = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
        Integer noOfDaysRemaining = startDate.daysBetween( endDate );
        system.debug( 'noOfDaysRemaining is '+ noOfDaysRemaining );
        
        if(noOfDaysRemaining > 28 && noOfDaysRemaining < 32){
            numberOfWeek = 5;
        }else if(noOfDaysRemaining > 21 && noOfDaysRemaining < 29){
            numberOfWeek = 4;
        }else if(noOfDaysRemaining > 14 && noOfDaysRemaining < 22){
            numberOfWeek = 3;
        }else if(noOfDaysRemaining > 7 && noOfDaysRemaining < 15){
            numberOfWeek = 2;
        }else{
            numberOfWeek = 1;
        }
        system.debug('numberOfWeek'+numberOfWeek);
        
        //Getting the project Names
        for(Project_Resource_Mapping__c PRM : projectList){
            projectNameByPRMId.put(PRM.Id,PRM.Project__r.Name);
        }
        
        //Creating the Monthly and weekly cards for Projects Resource Mapping..
        for(Project_Resource_Mapping__c PRM : projectList){
            Time_Entry_Monthly_Card__c monthCard = new Time_Entry_Monthly_Card__c();
            monthCard.Name = projectNameByPRMId.get(PRM.Id)+'-'+CurrentMonth+' Card';
            monthCard.Month_Start_Date__c = firstDayOfMonth;
            monthCard.Month_End_Date__c = endDate;
            monthCard.Project_Resource_Mapping__c =  PRM.Id;
            insert monthCard;
            //MonthlyCardList.add(monthCard);
            integer weekNum = 0;
            for(integer i = 0; i < numberOfWeek ; i++){
                weekNum++;
                Time_Entry_Weekly_Card__c tec = new Time_Entry_Weekly_Card__c();
                tec.Name = 'Week - '+(i +1);
                if(weekNum == 1){
                    tec.Week_Start_Date__c = firstDayOfMonth;
                    tec.Week_End_Date__c = firstDayOfMonth.addDays(7);
                }else if(weekNum == 5){
                    system.debug('Week 5');
                    tec.Week_Start_Date__c = firstDayOfMonth.addDays(7*(weekNum-1));
                    if(noOfDaysRemaining == 29){
                        tec.Week_End_Date__c = firstDayOfMonth.addDays(7*(weekNum-1)+1);
                    }else{
                        tec.Week_End_Date__c = firstDayOfMonth.addDays(7*(weekNum-1)+2);
                    }
                }else{
                    tec.Week_Start_Date__c = firstDayOfMonth.addDays(7*(weekNum-1));
                    tec.Week_End_Date__c = firstDayOfMonth.addDays(7*weekNum);
                }
                tec.Time_Entry_Monthly_Card__c = monthCard.Id;
                WeeklyCardList.add(Tec);
            }
        }
        insert WeeklyCardList;
    }
    
    
    @AuraEnabled
    Public Static porjectMappingWrapper  getMappingDetails(){
        List<Project_Resource_Mapping__c> totalResources    =[SELECT id,name,Card_Created__c,Contact__c,Project__c,Project_Name__c,Team_Member_Name__c,Type__c FROM Project_Resource_Mapping__c ];
        List<Project_Resource_Mapping__c> resourcesWithCard =[SELECT id,name,Card_Created__c,Contact__c,Project__c,Project_Name__c,Team_Member_Name__c,Type__c FROM Project_Resource_Mapping__c WHERE Card_Created__c= TRUE];
        List<Project_Resource_Mapping__c> resourcesWithoutCard  =[SELECT id,name,Card_Created__c,Contact__c,Project__c,Project_Name__c,Team_Member_Name__c,Type__c FROM Project_Resource_Mapping__c WHERE Card_Created__c= false];
        porjectMappingWrapper wrapperRec = new porjectMappingWrapper();
        wrapperRec.resourceOnProjects = totalResources.size();
        wrapperRec.resourcesWithDailyCards = resourcesWithCard.size();
        wrapperRec.resourcesWithoutDailyCards = resourcesWithoutCard.size();
        return wrapperRec;
    }
    @AuraEnabled
    Public Static integer getCaededPRMS(){
        List<Project_Resource_Mapping__c> getCaededPRMSList=[SELECT id,name,Card_Created__c,Contact__c,Project__c,Project_Name__c,Team_Member_Name__c,Type__c FROM Project_Resource_Mapping__c WHERE Card_Created__c= TRUE];
        Integer totatRcord=getCaededPRMSList.size();
        return totatRcord;
    }
    
    public class porjectMappingWrapper {
     @AuraEnabled public Integer resourceOnProjects;
     @AuraEnabled public Integer resourcesWithDailyCards;
     @AuraEnabled public Integer resourcesWithoutDailyCards;
    
 }
    
    
}