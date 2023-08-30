global class DailySchedulerBatch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        // Instantiate your batch class
        DynamicBatchForEmail batch = new DynamicBatchForEmail();
        
        // Start the batch job
        ID batchProcessId = Database.executeBatch(batch);
    }
}

// To schedule the batch job daily at 7 am
//String schedule = '0 0 7 * * ?'; // Cron expression for 7 am

// Schedule the job
//System.schedule('Daily Batch Job', schedule, new DailyScheduler());