#$redis = Redis::Namespace.new("twitter_clone", :redis => Redis.new)
if ENV["REDIS_PROVIDER"]
    $redis = Redis.new(:url => ENV["REDIS_PROVIDER"])
end