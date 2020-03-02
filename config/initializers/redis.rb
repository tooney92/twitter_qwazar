#$redis = Redis::Namespace.new("twitter_clone", :redis => Redis.new)
if ENV["REDISCLOUD_URL"]
    $redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
end