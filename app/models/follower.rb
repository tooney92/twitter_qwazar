class Follower
    def initialize(followers_id =" ", following_id = " ")
        @followersId = followers_id # my follower
        @followingId = following_id # people i'm following
    end

    #people following me
    def myFollower
        @myfollower = $redis.ZRANGE("followers:#{@following_id}", 0, -1)
        return @myfollower
    end

    #people i"m following
    def myFollowing
        @myfollowing = $redis.ZRANGE("following:#{@followersId}", 0, -1)
        return @myfollowing
    end

    #action to follow a person
    def Follow
        time = Time.now.to_i
        $redis.ZADD("followers:#{@followingId}", time, @followersId)
        if $redis.ZRANGE("followers:#{@followingId}", 0, -1).include?(@followersId)
            #add the user to the list of people you are following
            $redis.ZADD("following:#{@followersId}", time, @followingId)
            return true
        else
            return false
        end
    end

    def unfollow
        $redis.ZREM("followers:#{@followingId}", @followersId)
        if $redis.ZRANGE("followers:#{@followingId}", 0, -1).include?(@followersId)
            return false
        else
            return true
        end
        
    end
end
