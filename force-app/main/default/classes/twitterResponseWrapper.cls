public class twitterResponseWrapper{
		public String in_reply_to_screen_name{get;set;}
		public user user{get;set;}
		public String in_reply_to_user_id_str{get;set;}
		public String geo{get;set;}
		public String in_reply_to_user_id{get;set;}
		public String coordinates{get;set;}
		public String in_reply_to_status_id_str{get;set;}
		public String place{get;set;}
		public String in_reply_to_status_id{get;set;}
		public String contributors{get;set;}
		public String source{get;set;}
		public Boolean is_quote_status{get;set;}
		public entities entities{get;set;}
		public Integer retweet_count{get;set;}
		public Boolean truncated{get;set;}
		public Integer favorite_count{get;set;}
		public String text{get;set;}
		public Boolean favorited{get;set;}
		public String id_str{get;set;}
		public Boolean retweeted{get;set;}
		public Decimal id{get;set;}
		public String lang{get;set;}
		public String created_at{get;set;}
	public class user{
		public Boolean verified{get;set;}
		public Integer statuses_count{get;set;}
		public Boolean geo_enabled{get;set;}
		public String lang{get;set;}
		public String time_zone{get;set;}
		public Boolean contributors_enabled{get;set;}
		public String utc_offset{get;set;}
		public Boolean is_translator{get;set;}
		public Integer favourites_count{get;set;}
		public Boolean is_translation_enabled{get;set;}
		public String created_at{get;set;}
		public String profile_background_color{get;set;}
		public Integer listed_count{get;set;}
		public String profile_background_image_url{get;set;}
		public Integer friends_count{get;set;}
		public String profile_background_image_url_https{get;set;}
		public Integer followers_count{get;set;}
		public Boolean profile_background_tile{get;set;}
		//public Boolean protected{get;set;}
		public String profile_image_url{get;set;}
		public entities entities{get;set;}
		public String profile_image_url_https{get;set;}
		public String profile_sidebar_fill_color{get;set;}
		public String profile_text_color{get;set;}
		public String profile_sidebar_border_color{get;set;}
		public Boolean profile_use_background_image{get;set;}
		public String profile_link_color{get;set;}
		public Boolean has_extended_profile{get;set;}
		public String url{get;set;}
		public Boolean default_profile{get;set;}
		public String description{get;set;}
		public Boolean default_profile_image{get;set;}
		public String location{get;set;}
		public Boolean following{get;set;}
		public String screen_name{get;set;}
		public Boolean follow_request_sent{get;set;}
		public String name{get;set;}
		public Boolean notifications{get;set;}
		public String id_str{get;set;}
		public String translator_type{get;set;}
		public Decimal id{get;set;}
		public list<String> withheld_in_countries{get;set;}
	}
	public class entities{
		public description description{get;set;}
		public list<String> user_mentions{get;set;}
		public list<String> urls{get;set;}
		public list<String> symbols{get;set;}
		public list<String> hashtags{get;set;}
	}
	public class description{
		public list<String> urls{get;set;}
	}
}