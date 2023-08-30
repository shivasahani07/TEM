public class ReportsComponentHelper {
    
    Public Static void ShowReports(){
        // Querying reports in Apex
        List<Report> reports = [SELECT Id, Name, DeveloperName, NamespacePrefix FROM Report];
        
        // Loop through the queried reports
        for (Report report : reports) {
            System.debug('Report Name: ' + report.Name);
            System.debug('Developer Name: ' + report.DeveloperName);
            System.debug('Namespace Prefix: ' + report.NamespacePrefix);
             System.debug('Report Id-------->: ' + report.Id);
            // You can access other fields of the Report object as well
        }
    }
    
    public void myMethod() {
        
        
    }
    
}