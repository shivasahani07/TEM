public class TwitterTweetWrapper {
    public List<TweetData> data;
    public MetaData meta;

    public class TweetData {
        public List<String> edit_history_tweet_ids;
        public String id;
        public String text;
        public String created_at;
    }

    public class MetaData {
        public String newest_id;
        public String oldest_id;
        public Integer result_count;
        public String next_token;
    }
}