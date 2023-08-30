public class FacebookCallbackController {
	// Replace this with your desired post-login landing page URL
    private static final String POST_LOGIN_LANDING_PAGE_URL = 'https://sales-production--sales.sandbox.lightning.force.com/';

    public String getPostLoginLandingPageUrl() {
        return POST_LOGIN_LANDING_PAGE_URL;
    }
}