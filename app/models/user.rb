class User
    require 'securerandom'
    def add(username = "test", pass ="test", email = "test")
        @salt = SecureRandom.base64(8)
        @username = username
        @password = Digest::SHA2.hexdigest(@salt + pass)
        @email = email
    end
    def save
        @id = $redis.incr("users")
        $redis.hmset("user:#{@id}", "username", @username, "password", @password, "email", @email, "date_joined", Time.now().strftime("joined %B, %Y"), "salt", @salt)
        $redis.set(@username, @id)
        $redis.sadd("email", @email)
        $redis.sadd("username", @username)
        return true
    end

    def auth(username, password)
        if $redis.get(username) == nil
            return "sorry invalid name!"
        else
            passwords = Digest::SHA2.hexdigest(fetch_user(username)["salt"] + password.to_s)
            return passwords == fetch_user(username)["password"]
        end
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

    def exists(username)
        if  $redis.get(username) != nil
            return true
        end
    end
    #$.sadd("myset", "mail")
    # self.salt = ActiveSupport::SecureRandom.base64(8)
    # self.hashed_password = Digest::SHA2.hexdigest(self.salt + submitted_password)

end
