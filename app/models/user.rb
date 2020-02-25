class User
    def add(username = "test", pass ="test", email = "test")
        @username = username
        @password = pass
        @email = email
    end
    def save
        @id = $redis.incr("users")
        $redis.hmset("user:#{@id}", "username", @username, "password", @password, "email", @email)
        return true
    end

    def user_id
        return @id
    end


end
