class User
    require 'securerandom'
    def add(username = "test", pass ="test", email = "test")
        @salt = SecureRandom.base64(8)
        @username = username
        @password = Digest::SHA2.hexdigest(@salt + pass)
        @email = email
    end
    def save
        @auth =
        @id = $redis.incr("users")
        $redis.hmset("user:#{@id}", "username", @username, "password", @password, "email", @email, "date_joined", Time.now().strftime("%B, %Y"), "salt", @salt, "bio", "nil", "location", "nil", "date_of_birth", "nil", "website", "nil", "profile_image_url", "nil","profile_banner_url", "nil")
        $redis.set(@username, @id)
        $redis.set(@id, @username)
        $redis.sadd("email", @email)
        $redis.sadd("username", @username)
        return true
    end

    def profile_update(username, bio, location, date_of_birth, website, image,banner)
        $redis.hmset("user:#{getkey(username)}", "bio", bio, "location", location, "date_of_birth", date_of_birth, "website", website, "profile_image_url", image, "profile_banner_url", banner )
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
    def getname(key)
        username = $redis.get(key)
        if username == nil 
            return "sorry user does not exist, check username"
        else
            return username
        end
    end
    def getUserImage(key)
        username = $redis.get(key)
        image = fetch_user(username)["profile_image_url"]
        
        return image
      
    end

    def fetch_user(username)
        user = $redis.hgetall("user:#{getkey(username)}")
        return user
    end
    def fetch_userkey(key)
        user = $redis.hgetall("user:#{getname(key)}")
        return user
    end

    def fetch_allusers
        model = User.new()
        users_data = $redis.smembers("username").map{ |user| model.fetch_user(user)}
        return users_data
    end

    def exists(username, email)
        if  $redis.sismember("username", username)
            return "username already exists"
        elsif $redis.sismember("email", email)
            return "email already exists"
        else
            return false
        end
    end

end
