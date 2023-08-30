trigger TriggerOnCase on Case (after insert) {
    
    if(trigger.isInsert && trigger.isafter){
        TriggerOnCaseHelper.getRepliesForTweet(Trigger.new);
    }

}