class Post
    # name = session[:userName]
    def initialize(user_id=" ", post_id=" ", tweet=" ")
        @userId = user_id
        @postId = post_id
        @tweet = tweet
    end

    def create
        time = Time.now
        $redis.HMSET("tweet:#{@postId}","user_id", @userId ,"time",time,"body",@tweet)
        #@followerModel = Follower.new("", "1000")
        @followers = $redis.ZRANGE("followers:#{@userId}", 0, -1)
        @followers << @userId
        if @followers.any?
            @followers.each do |n|
                $redis.LPUSH("posts:#{n}", @postId)
            end
        end

    end

    
    def user(num)
        return $redis.get(num)
    end

    def all(num)
        post_arr = $redis.LRANGE("posts:#{num}", 0, -1)
        
        all_tweets = []
        post_arr.each do |n|
            tweet = {}
            tweet["body"] = $redis.HGET("tweet:#{n}", "body")
            tweet["time"] = $redis.HGET("tweet:#{n}", "time")
            tweet["user_id"] = $redis.HGET("tweet:#{n}", "user_id")
            all_tweets << tweet
        end
        return all_tweets
    end
end
