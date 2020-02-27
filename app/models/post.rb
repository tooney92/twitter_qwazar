class Post
    def initialize(user_id, post_id, tweet)
        @userId = user_id
        @postId = post_id
        @tweet = tweet
    end

    def create
        time = Time.now.to_i
        $redis.HMSET("tweet:#{@postId}","user_id", @userId ,"time",time,"body",@tweet)
        #@followerModel = Follower.new("", "1000")
        @followers = $redis.ZRANGE("followers:1000", 0, -1)
        @followers << @userId
        if @followers.any?
            @followers.each do |n|
                $redis.LPUSH("posts:#{n}", @postId)
            end
        end

    end
end
