#$redis = Redis::Namespace.new("twitter_clone", :redis => Redis.new)
# if ENV["REDIS_PROVIDER"]
#     $redis = Redis.new(:url => ENV["REDIS_PROVIDER"])
# end
ENV["REDISTOGO_URL"] = 'redis://redistogo:4672deadc8b11656fcb0e0fad8c06c52@pike.redistogo.com:10427/'
uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/" )
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)