import { LightningElement,api,wire,track } from 'lwc';
import instLogo from '@salesforce/resourceUrl/InstagramLogo';
import { refreshApex } from '@salesforce/apex';
import getSessionId from '@salesforce/apex/FBAuthController.getSessionId';
import { loadScript } from "lightning/platformResourceLoader";
import cometdlwc from "@salesforce/resourceUrl/cometd";
import getCaseDetails from '@salesforce/apex/FBAuthController.getCaseDetails';
import getRepliesDetails from '@salesforce/apex/FBAuthController.getRepliesDetails';
import postCommentToFB from '@salesforce/apex/FBAuthController.postCommentToFB';


export default class FacebookHandler extends LightningElement {

//FOR COMET D
libInitialized = false;
    @track sessionId;
    @track error;

    spring20Logo = instLogo;
    @api recordId='500Hy00000K0HOiIAN';
    @track serverResponseData=[];
    error;
    relatedCommentList=[];
    tweetDescription;
    relatedReplyList=[];
    postUrl;
    comment;
    commentedBy;
    commentId;
    parentId;
    selectedCommentId;
    replyMessage;
    parentCommentId;
    noReply=false;
    formattedDescriptionText;
    @api showReplies=false;
    @api isModalOpen = false;
    @api selectedCommentValue = '';
    @api selectedCommentRepliedBy = '';
    @track spinner = false;
    @track replyMessage;

     formattedDescription() {
         debugger;
        // Regular expressions to match #tags, @mentions, and links
        const tagRegex = /#(\w+)/g;
        const mentionRegex = /@(\w+)/g;
        const linkRegex = /http[s]?:\/\/[^\s]+/g;

        let formattedText = this.tweetDescription;

        // Highlight #tags with a custom class
        formattedText = formattedText.replace(tagRegex, '<span class="tag">$&</span>');

        // Highlight @mentions with a custom class
        formattedText = formattedText.replace(mentionRegex, '<span class="mention">$&</span>');

        // Create links for URLs
        formattedText = formattedText.replace(linkRegex, '<a href="$&" target="_blank">$&</a>');
        this.formattedDescriptionText=formattedText;
        return formattedText;
    }


    @wire(getCaseDetails,{recordId:'$recordId'})
    serverResponse({ error, data }) {
        debugger;
        if (data) {
           this.serverResponseData=data;
           this.tweetDescription=this.serverResponseData.description;
           this.postUrl=this.serverResponseData.commentWrapperList[0].PostUrl;
           this.relatedCommentList=this.serverResponseData.commentWrapperList;
           setTimeout(() => this.template.querySelector('c-pagination-dynamic').setPagination(10));
           this.formattedDescription();
        this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }


     @wire(getSessionId)
    wiredSessionId({ error, data }) {
        if (data) {
            console.log(data);
            this.sessionId = data;
            this.error = undefined;
            loadScript(this, cometdlwc)
            .then(() => {
                this.initializecometd()
            });
        } else if (error) {
            console.log(error);
            this.error = error;
            this.sessionId = undefined;
        }
    }

     //CometD
    initializecometd() {
        const self = this;
        if (this.libInitialized) {
          return;
        }
      
        this.libInitialized = true;
      
        //inintializing cometD object/class
        var cometdlib = new window.org.cometd.CometD();
              
        //Calling configure method of cometD class, to setup authentication which will be used in handshaking
        cometdlib.configure({
          url: window.location.protocol + '//' + window.location.hostname + '/cometd/47.0/',
          requestHeaders: { Authorization: 'OAuth ' + this.sessionId},
          appendMessageTypeToURL : false,
          logLevel: 'debug'
        });
      
        cometdlib.websocketEnabled = false;
      
        cometdlib.handshake(function(status) {          
            if (status.successful) {
                // Successfully connected to the server.
                // Now it is possible to subscribe or send messages
                console.log('Successfully connected to server');

                const messageCallBack = function(message){
                    console.log('NewMessage',message);

                    let newmessage = message.data.payload;

                    if(newmessage.CaseId__c==self.recordId){
                         refreshApex(this.serverResponseData);
                        
                    }
                }

                cometdlib.subscribe('/event/Chat_Message_Event__e', messageCallBack);
            }else {
              /// Cannot handshake with the server, alert user.
              console.error('Error in handshaking: ' + JSON.stringify(status));
            }
         });
    }

    @track recordsToDisplay = [];
    jobPaginationCallback(event){
        this.recordsToDisplay = event.detail.recordToDisplay;
    } 

    openModel(event){
        debugger;
        this.isModalOpen = true;
        this.comment=event.target.value;
        this.commentedBy=event.target.name;
        this.commentId=event.target.title;
        this.parentId=event.target.variant;
    } 

     closeModel() {
        // Close the modal
        this.isModalOpen = false;
        this.showReplies=false;
    }


    // this method will show comments reply
    viewCommentReplies(event){
        debugger
        let commentId =event.target.title;
        let commentedBy =event.target.name;
        this.selectedCommentRepliedBy=commentedBy;

        getRepliesDetails({commentId:this.commentId,commentText:this.replyMessage,parentSFID:this.parentId,caseId:this.recordId})
        .then((result) => {
            if(result.length>0)
            this.relatedReplyList=result;
            else{
                this.noReply=true
            }
          
        })
        .catch((error) => {
            this.error = error;
        });

        this.showReplies=true;

        
    }

    getReplyvalyChange(event){
        debugger;
        this.replyMessage=event.target.value;
    }

    
    postComment() {
        debugger;
        postCommentToFB({commentId:this.commentId,commentText:this.replyMessage,parentSFID:this.parentId,caseId:this.recordId})
        .then((result) => {
            alert('Replied');
          
        })
        .catch((error) => {
            this.error = error;
             alert('Error');
        });

    }  

    refreshComments(){
        debugger;
        refreshApex(this.serverResponseData);
    } 
}