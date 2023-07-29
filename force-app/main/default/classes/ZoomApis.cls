Public class ZoomApis {
    public String bodyprint{get;set;}
    public String pswrd{get;set;}
    
    public  Static String createMeeting(String Subject,String startSlot,Decimal Duration) {
        
        Zoom_Api__c Zoom_Details = [Select id,Endpoint_URL__c,JWT_Token__c from Zoom_Api__c];
        system.debug('startSlot'+startSlot+'Duration'+startSlot);
        ZoomApis.createMeetingWapper newWapper = new ZoomApis.createMeetingWapper();
        newWapper.topic = Subject;
        newWapper.type = 2;
        newWapper.start_time = startSlot;//'2021-04-21T16:54:14Z';
        newWapper.duration = integer.valueOf(Duration);
        newWapper.timezone = 'Asia/Kolkata';
        string jsonString = JSON.serialize(newWapper);
        System.debug('jsonString >>'+jsonString); 
        
        String endPoint = Zoom_Details.Endpoint_URL__c;
        System.debug('endPoint :::'+endPoint);
          System.debug('JWT_Token__c :::'+Zoom_Details.JWT_Token__c);
        HttpRequest req = new HttpRequest();
        req.setBody(jsonString);
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Authorization', 'bearer '+Zoom_Details.JWT_Token__c);
        req.setEndpoint(endPoint); 
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if(res.getStatusCode() == 201){
            // bodyprint = res.getBody();
            ZoomResponseWrapper respWrapObj = ZoomResponseWrapper.parse(res.getBody());
            //bodyprint = respWrapObj.join_url.substringBefore('?');
            //pswrd = respWrapObj.join_url.substringAfter('?');
            //pswrd = pswrd.replace('pwd=', 'Password : ');
            System.debug('Meeting Link >>>' +respWrapObj.join_url);
            System.debug('res pass >>>' +res.getBody());         
            return respWrapObj.join_url;
        }else{
            System.debug('res fail >>>' +res.getBody());
            return 'res.getBody()';
        }
    }
    
    public Static String deleteMeeting(String meetingId){
        try{
            Zoom_Api__c Zoom_Details = [Select id,Endpoint_URL__c,JWT_Token__c from Zoom_Api__c];
            String MeetingIdToDeleteEndPointURL = Label.MeetingEndURL+meetingId;
            System.debug('MeetingIdToDeleteEndPointURL ::'+MeetingIdToDeleteEndPointURL);
            HttpRequest req = new HttpRequest();
            req.setMethod('DELETE');
            req.setHeader('Content-type', 'text/plain');
            req.setHeader('Authorization', 'bearer '+Zoom_Details.JWT_Token__c);
            req.setEndpoint(MeetingIdToDeleteEndPointURL); 
            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug('Status Code ::'+res.getStatusCode());
            System.debug('res.getBody() ::'+res.getBody());
            if(res.getStatusCode() == 204){
                System.debug('Meeting Delete Successfullly');
            }
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('Error ::'+e.getMessage() + '&& Error Line No ::'+e.getLineNumber());
        }
        return 'ERROR';
    }
    
    public class createMeetingWapper{
        Public String topic {get;set;}
        Public Integer type {get;set;}
        Public String start_time {get;set;}
        Public Integer duration {get;set;}
        Public String timezone {get;set;}
        Public String password {get;set;}
    }
}