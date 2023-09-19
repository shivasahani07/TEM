import { LightningElement,track,wire,api } from 'lwc';
import instLogo from '@salesforce/resourceUrl/InstagramLogo';
import getCaseDetails from '@salesforce/apex/instaComponentController.getCaseDetails';
import getRepliesDetails from '@salesforce/apex/instaComponentController.getRepliesDetails';
import replyToComment from '@salesforce/apex/instaComponentController.replyToComment';



export default class InstagramHandler extends LightningElement {
    spring20Logo = instLogo;
    @api recordId='5006D000007cZoRQAU';
    @track serverResponseData=[];
    error;
    relatedCommentList=[];
    tweetDescription;
    relatedReplyList=[];
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

    @wire(getCaseDetails,{recordId:'$recordId'})
    serverResponse({ error, data }) {
        debugger;
        if (data) {
           this.serverResponseData=data;
           this.relatedCommentList=this.serverResponseData;
           setTimeout(() => this.template.querySelector('c-pagination-dynamic').setPagination(5));
        this.error = undefined;
        } else if (error) {
            this.error = error;
        }
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
        replyToComment({commentId:this.commentId,commentText:this.replyMessage,parentSFID:this.parentId,caseId:this.recordId})
        .then((result) => {
            alert('Replied');
          
        })
        .catch((error) => {
            this.error = error;
             alert('Error');
        });

    }

}