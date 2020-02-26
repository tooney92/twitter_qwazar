class User
    def initialize(username, pass, email)
        @username = username
        @password = pass
        @email = email
    end

    def save
        id = $redis.INC(next_user_id)
        $redis.HMSET("user:#{id}", "username", @username, "password", @password, "email", @email)
        return true
    end
end
