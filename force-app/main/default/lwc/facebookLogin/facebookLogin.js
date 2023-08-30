import { LightningElement, wire } from 'lwc';
import initiateFacebookLogin from '@salesforce/apex/FBAuthController.initiateFacebookLogin';

export default class FacebookLogin extends LightningElement {
    
    facebookLoginUrl;

    @wire(initiateFacebookLogin)
    wiredFacebookLoginUrl({ error, data }) {
        if (data) {
            debugger;
            this.facebookLoginUrl = data;
        } else if (error) {
        console.error('Error retrieving Facebook login URL:', error);
        // Handle error message display or other error handling logic here
        }
    }

    handleFacebookLogin() {
        if (this.facebookLoginUrl) {
        // Open a popup window for Facebook login
            //window.open(this.facebookLoginUrl, '_blank');
            const width = 600;
            const height = 400;
            const left = (window.innerWidth - width) / 2;
            const top = (window.innerHeight - height) / 2;
            const options = `width=${width},height=${height},top=${top},left=${left},status=no,toolbar=no,menubar=no,location=no`;

            window.open(this.facebookLoginUrl, 'Facebook Login', options);
        }
    }
}