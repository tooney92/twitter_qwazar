class Follower
    def initialize(followers_id=0, following_id=0)
        @followersId = followers_id # my follower
        @followingId = following_id # people i'm following
    end

    #people following me
    def myFollower
        @myfollower = $redis.ZRANGE("followers:#{@followingId}", 0, -1)
        return @myfollower
    end

    #people i"m following
    def myFollowing
        @myfollowing = $redis.ZRANGE("following:#{@followingId}", 0, -1)
        return @myfollowing
    end

    #action to follow a person
    def Follow
        time = Time.now.to_i
        $redis.ZADD("followers:#{@followersId}", time, @followingId)
        if $redis.ZRANGE("followers:#{@followersId}", 0, -1).include?(@followingId)
            #add the user to the list of people you are following
            $redis.ZADD("following:#{@followingId}", time, @followersId)
            return true
        else
            return false
        end
    end

    def unfollow
        $redis.ZREM("followers:#{@followersId}", @followingId)
        $redis.ZREM("following:#{@followingId}", @followersId)
        return true
        
    end
end
