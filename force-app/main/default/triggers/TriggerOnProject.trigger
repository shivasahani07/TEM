trigger TriggerOnProject on Project__c (after update,after insert,before insert,before update) {
    if(trigger.isAfter && trigger.isInsert){
        TriggerOnProjectHelper.createDefualtMileStoneCS(Trigger.new);
        //TriggerOnProjectHelper.sendEmailWithThreeColumnTable(Trigger.new);
        ProjectEmailPreparation.sendEmailWithThreeColumnTable(Trigger.new);

    }
}