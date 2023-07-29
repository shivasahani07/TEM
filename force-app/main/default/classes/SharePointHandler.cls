public without sharing class SharePointHandler {
    public static String getFiles(){
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();

        //ID- b05de981-8da4-43b6-9f16-cb14957f7668
        //KEY- LM97O8UFEXCZyPKNsG8jnE3X/iMsqBrJHPuiUkfhXZ0=
        req.setEndpoint('callout:SPSF/sites/UtilitariansProjects/_api/web/lists/GetByTitle('+'\'Documents\''+')/items');
        req.setMethod('GET');

        HTTPResponse res = http.send(req);
        return JSON.serialize(res.getBody());
    }


    public static String getAllFilesAndFoldersInSites(String sites, String folderName,String type){
        // https://utillabs.sharepoint.com/sites/UtilitariansProjects/_api/web/GetFolderByServerRelativeUrl('/sites/UtilitariansProjects/Shared%20Documents')/Folders
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();
        String url = 'sites/'+sites+'/_api/web/GetFolderByServerRelativeUrl('+'\'/sites/'+sites+'/'+folderName+'\''+')/'+type;
        System.debug('URL------'+url);
        req.setEndpoint('callout:SPSF/'+url);
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json;odata=verbose');
        req.setHeader('odata-version','');

        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return JSON.serialize(res.getBody());
    }

    public static String createFolderInsideSite(String siteName,String path){
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();

        String url = siteName+'/_api/web/folders';
        String body = '{\'__metadata\':{\'type\':\'SP.Folder\'},\'ServerRelativeUrl\':\''+path+'\'}';

        System.debug(body);
        
        req.setHeader('Accept', 'application/json;odata=verbose');
        req.setHeader('odata-version','');
        req.setHeader('Content-Type','application/json;odata=verbose');
        req.setHeader('X-RequestDigest','{form_digest_value}');
        req.setBody(body);
        req.setMethod('POST');
        req.setEndpoint('callout:SPSF/sites/'+url);

        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return JSON.serialize(res.getBody());
    }

     public static String deleteFolderInsideSite(String siteName,String folderName){

        String url = 'sites/'+siteName+'/_api/web/GetFolderByServerRelativeUrl('+'\'/sites/'+siteName+'/'+folderName+'\')';

        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();

        req.setHeader('Accept', 'application/json;odata=verbose');
        req.setHeader('Content-Type','application/json;odata=verbose');
        req.setHeader('If-Match','*');
        req.setHeader('Content-Length', '0');
        req.setHeader('X-HTTP-Method','DELETE');
        req.setHeader('X-RequestDigest','{form_digest_value}');

        req.setMethod('POST');
        req.setEndpoint('callout:SPSF/'+url);

        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return JSON.serialize(res.getBody());
    }


    public static String createFileInsideSite(String siteName,String folderName,String fileName){
        String url = 'sites/'+siteName+'/_api/web/GetFolderByServerRelativeUrl('+'\'/sites/'+siteName+'/'+folderName+'\')/Files/add(url=\''+fileName+'\',overwrite=true)';

        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();

        String body = 'Ly8gUmVxdWVzdCBCb2R5LS0tLQ0KDQp7DQogICJjdXN0b21lcl9ncm91cGluZyI6ICJaMDAxIiwNCiAgInBhcnRuZXJfcm9sZSI6ICJTWTAwMDFYIiwNCiAgImN1c3RvbWVyX25hbWUiOiAiQWtoaWwgSyBHIiwNCiAgInN0cmVldF8yIjogIk5POjgwLEJPTU1BU0FORFJBIElORFVTVFJJQUwgQVJFQSIsDQogICJzdHJlZXRfMyI6ICJBTkVLQUwgVEFMVUssIEhPU1VSIFJPQUQsIiwNCiAgInN0cmVldCI6ICJJTkRVU1RSSUFMIEFSRUEsIENIRU1CQU5PT1IiLA0KICAicG9zdGFsX0NvZGUiOiAiNjgzNTcyIiwNCiAgImNpdHkiOiAiQU5HQU1BTFkiLA0KICAiY291bnRyeSI6ICJJTiIsDQogICJyZWdpb24iOiAzMiwNCiAgImxhbmd1YWdlIjogIkVOIiwNCiAgInRlbGVwaG9uZV9udW1iZXIiOiAiOTI0OTUwMDAwMiIsDQogICJtb2JpbGVfbnVtYmVyIjogIjkyNDk1MDAwMDIiLA0KICAiZW1haWwiOiAibW9vbGFuc2dyb3VwQGdtYWlsLmNvbSIsDQogICJ0YXhfdHlwZSI6ICIwOSIsDQogICJnc3Rpbl9udW1iZXIiOiAiMzJBQUNDTTMyNTlOMVpCIiwNCiAgInBhbl9udW1iZXIiOiAiQUFDQ00zMjU5TiINCn0NCg0KDQovLyBSZXNwb25zZSAtIFN1Y2Nlc3MNCg0Kew0KICAgICJzdGF0dXMiOnRydWUsDQogICAgImN1c3RvbWVyX2lkIjoiV0VXRVBXSUUzMjMyMzIzMiIsDQp9DQoNCi8vIFJlc3BvbnNlIC0gRXJyb3INCg0Kew0KICAgICJzdGF0dXMiOnRydWUsDQogICAgIm1lc3NhZ2UiOiJFcnJvciBtZXNzYWdlIGhlcmUiLA0KfQ0KDQo=';

        req.setHeader('Accept', 'application/json;odata=verbose');
        req.setHeader('Content-Type','application/json;odata=verbose');
        req.setHeader('Content-Length', '0');
        req.setHeader('X-RequestDigest','{form_digest_value}');
        req.setBody(EncodingUtil.base64Decode(body).toString());

        req.setMethod('POST');
        req.setEndpoint('callout:SPSF/'+url);

        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return JSON.serialize(res.getBody());
    }

    public static String deleteFileInsideSite(String siteName,String folderName){
        String url = 'sites/'+siteName+'/_api/web/GetFileByServerRelativeUrl('+'\'/sites/'+siteName+'/'+folderName+'\')';

        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();

        req.setHeader('Accept', 'application/json;odata=verbose');
        req.setHeader('Content-Type','application/json;odata=verbose');
        req.setHeader('If-Match','*');
        req.setHeader('Content-Length', '0');
        req.setHeader('X-HTTP-Method','DELETE');
        req.setHeader('X-RequestDigest','{form_digest_value}');

        req.setMethod('POST');
        req.setEndpoint('callout:SPSF/'+url);

        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return JSON.serialize(res.getBody());
    }


    @Auraenabled(cacheable=true)

    public static Map<String, Object> getSites(){
        //fix
       // https://utillabs.sharepoint.com/
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();
        // String url = '_api/search/query?%20querytext=%27contentclass:STS_Site%20contentclass:STS_Web%27%20&selectproperties=%27Title,Path%27&rowlimit=500';
        //String url = '_api/search/query?querytext=%27contentClass:STS_Site%27&trimduplicates=false&selectproperties=%27SiteLogo%2cTitle%27';
        String url = '_api/search/query?querytext=%27contentClass:STS_Site%27&trimduplicates=false&rowlimit=5000&selectproperties=%27SiteLogo,Title%27&refinementfilters=%27SPSiteUrl:(%22https://utillabs.sharepoint.com/sites/*%22)%27' ;//Accurate;
        req.setEndpoint('callout:SPSF/'+url);
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json;odata=verbose');
        req.setHeader('odata-version','');

        HTTPResponse res = http.send(req);
        System.debug(res.getBody());

        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        Map<String,Object> m2 =  (Map<String, Object>) m.get('d');
        Map<String,Object> m3 =  (Map<String, Object>) m2.get('query');
        Map<String,Object> m4 =  (Map<String, Object>) m3.get('PrimaryQueryResult');
        Map<String,Object> m5 =  (Map<String, Object>) m4.get('RelevantResults');
        Map<String,Object> m6 =  (Map<String, Object>) m5.get('Table');
        Map<String,Object> m7 =  (Map<String, Object>) m6.get('Rows');

        return m7;
    }

}