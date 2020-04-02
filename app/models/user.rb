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
        $redis.hmset("user:#{@id}", "username", @username, "password", @password, "admin_status", "false", "email", @email, "date_joined", Time.now().strftime("%B, %Y"), "salt", @salt, "bio", "nil", "location", "nil", "date_of_birth", "nil", "website", "nil", "profile_image_url", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTVsThWV87XN3bvVT3DYGy7v7lL6b4rza8saDmVyVK6hGWy-MQt", "profile_banner_url", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQhtV91m6SV2Yyt72b5a_2OaKMHtqcTdUQm-3YeVIGmYpbLPEKX")
        $redis.set(@username, @id)
        $redis.set(@id, @username)
        $redis.set(@email, @username)
        $redis.sadd("email", @email)
        $redis.sadd("username", @username)
        return true
    end

    def profile_update(username, bio, location, date_of_birth, website, image, banner)
        $redis.hmset("user:#{getkey(username)}", "bio", bio, "location", location, "date_of_birth", date_of_birth, "website", website, "profile_image_url", image, "profile_banner_url", banner)
    end

    def auth(username, password)
        if $redis.get(username) == nil
            return "sorry invalid name!"
        else
            if $redis.sismember("username", username)
                passwords = Digest::SHA2.hexdigest(fetch_user(username)["salt"] + password.to_s)
                return passwords == fetch_user(username)["password"]
            else
                username = $redis.get(username)
                passwords = Digest::SHA2.hexdigest(fetch_user(username)["salt"] + password.to_s)
                return passwords == fetch_user(username)["password"]
            end

        end
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

    def set_token(email)
        token = SecureRandom.uuid
        $redis.set(token, email)
        return token
    end

    def token_get_email(token)
        return $redis.get(token)
    end

    def email_fetch_user(email)
        return $redis.get(email)
    end

    def hash_and_update_password(user_id, password)
        # sample_user = fetch_user("test94")
        salt = SecureRandom.base64(8)
        new_encrypted_password = Digest::SHA2.hexdigest(salt + password)
        $redis.hmset("user:#{user_id}", "salt", salt, "password", new_encrypted_password)
    end

    def delete_user(key)
        user_name = $redis.get(key)
        user_key = getkey(user_name)
        user_email = $redis.hgetall("user:#{user_key}")["email"]
        $redis.srem("username", user_name)
        $redis.srem("email", user_email)
        $redis.del("user:#{user_key}")
        $redis.del(user_key)
        $redis.del(user_name)
        $redis.del(user_email)
        return "done!"
    end

    def make_admin(key)
        $redis.hmset("user:#{key}", "admin_status", true)
    end
    def remove_admin(key)
        $redis.hmset("user:#{key}", "admin_status", false)
    end

    def edit_user(key, email, username)
        old_user_name = $redis.get(key)
        old_user_email = $redis.hgetall("user:#{key}")["email"]
        new_User_name = username
        new_User_email = email
        $redis.del(old_user_name)
        $redis.del(old_user_email)
        $redis.srem("email", old_user_email)
        $redis.srem("username", old_user_name)
        $redis.hmset("user:#{key}", "username", new_User_name, "email", new_User_email)
        $redis.mset(key, new_User_name)
        $redis.set(new_User_name, key)
        $redis.set(new_User_email, new_User_name)
        $redis.sadd("email", new_User_email)
        $redis.sadd("username", new_User_name)
        # return "#{fetch_user(username)}"
    end

    # # $redis.set(@id, @username)

    # $redis.del(user_key)
    # $redis.del(user_email)


end
