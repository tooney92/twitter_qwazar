class User
    def add(username = "test", pass ="test", email = "test")
        @username = username
        @password = pass
        @email = email
    end
    def save
        @id = $redis.incr("users")
        $redis.hmset("user:#{@id}", "username", @username, "password", @password, "email", @email)
        $redis.set(@username, @id)
        return true
    end

    def user_id
        return @id
    end

    def getkey(username)
        key = $redis.get(username)
        if key == nil 
            return "sorry user does not exist, check username"
        else
            return key
        end
    end

    def fetch_user(username)
        user = $redis.hgetall("user:#{getkey(username)}")
        return user
    end

    

end
