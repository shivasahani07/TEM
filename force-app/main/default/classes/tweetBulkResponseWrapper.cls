public class tweetBulkResponseWrapper {

	public cls_statuses[] statuses;
	public cls_search_metadata search_metadata;
	class cls_statuses {
		public String created_at;	//Thu Apr 13 05:31:19 +0000 2023
		public Integer id;	//1646385556635676700
		public String id_str;	//1646385556635676676
		public String text;	//@Web3_Protocol @Metacoms Lfg @imVkohli 
		public boolean truncated;
		public cls_entities entities;
		public cls_metadata metadata;
		public String source;	//<a href="http://twitter.com/download/android" rel="nofollow">Twitter for Android</a>
		public Integer in_reply_to_status_id;	//1646124091265659000
		public String in_reply_to_status_id_str;	//1646124091265658883
		public Integer in_reply_to_user_id;	//1315173107884150800
		public String in_reply_to_user_id_str;	//1315173107884150785
		public String in_reply_to_screen_name;	//Web3_Protocol
		public cls_user user;
		public cls_geo geo;
		public cls_coordinates coordinates;
		public cls_place place;
		public cls_contributors contributors;
		public boolean is_quote_status;
		public Integer retweet_count;	//0
		public Integer favorite_count;	//0
		public boolean favorited;
		public boolean retweeted;
		public String lang;	//und
	}
	class cls_entities {
		public cls_description description;
	}
	class cls_hashtags {
	}
	class cls_symbols {
	}
	class cls_user_mentions {
		public String screen_name;	//Web3_Protocol
		public String name;	//Web3 Protocol (We're Hiring !!)
		public Integer id;	//1315173107884150800
		public String id_str;	//1315173107884150785
		public cls_indices[] indices;
	}
	class cls_indices {
	}
	class cls_urls {
	}
	class cls_metadata {
		public String iso_language_code;	//und
		public String result_type;	//recent
	}
	class cls_user {
		public Integer id;	//1466795290338365400
		public String id_str;	//1466795290338365444
		public String name;	//BRANDAL MALAM&#124;Metatime
		public String screen_name;	//Hanterx_Suiswap
		public String location;	//
		public String description;	//#Metatime
		public cls_url url;
		public cls_entities entities;
		//public boolean protected;
		public Integer followers_count;	//130
		public Integer friends_count;	//4270
		public Integer listed_count;	//12
		public String created_at;	//Fri Dec 03 15:44:15 +0000 2021
		public Integer favourites_count;	//1813
		public cls_utc_offset utc_offset;
		public cls_time_zone time_zone;
		public boolean geo_enabled;
		public boolean verified;
		public Integer statuses_count;	//2873
		public cls_lang lang;
		public boolean contributors_enabled;
		public boolean is_translator;
		public boolean is_translation_enabled;
		public String profile_background_color;	//F5F8FA
		public cls_profile_background_image_url profile_background_image_url;
		public cls_profile_background_image_url_https profile_background_image_url_https;
		public boolean profile_background_tile;
		public String profile_image_url;	//http://pbs.twimg.com/profile_images/1480803793302261762/mILJbrM1_normal.jpg
		public String profile_image_url_https;	//https://pbs.twimg.com/profile_images/1480803793302261762/mILJbrM1_normal.jpg
		public String profile_banner_url;	//https://pbs.twimg.com/profile_banners/1466795290338365444/1638558208
		public String profile_link_color;	//1DA1F2
		public String profile_sidebar_border_color;	//C0DEED
		public String profile_sidebar_fill_color;	//DDEEF6
		public String profile_text_color;	//333333
		public boolean profile_use_background_image;
		public boolean has_extended_profile;
		public boolean default_profile;
		public boolean default_profile_image;
		public cls_following following;
		public cls_follow_request_sent follow_request_sent;
		public cls_notifications notifications;
		public String translator_type;	//none
		public cls_withheld_in_countries[] withheld_in_countries;
	}
	class cls_url {
	}
	class cls_description {
		public cls_urls[] urls;
	}
	class cls_utc_offset {
	}
	class cls_time_zone {
	}
	class cls_lang {
	}
	class cls_profile_background_image_url {
	}
	class cls_profile_background_image_url_https {
	}
	class cls_following {
	}
	class cls_follow_request_sent {
	}
	class cls_notifications {
	}
	class cls_withheld_in_countries {
	}
	class cls_geo {
	}
	class cls_coordinates {
	}
	class cls_place {
	}
	class cls_contributors {
	}
	class cls_search_metadata {
		public Double completed_in;	//0.103
		public Integer max_id;	//1646385556635676700
		public String max_id_str;	//1646385556635676676
		public String next_results;	//?max_id=1646384701488365567&q=%40imVkohli&include_entities=1&result_type=recent
		public String query;	//%40imVkohli
		public String refresh_url;	//?since_id=1646385556635676676&q=%40imVkohli&result_type=recent&include_entities=1
		public Integer count;	//15
		public Integer since_id;	//0
		public String since_id_str;	//0
	}
	

	
    
    
}