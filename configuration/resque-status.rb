require 'resque/status_server'
REDIS_RESQUE_DATABASE_NO = 8
Resque.redis = "localhost:6379:#{REDIS_RESQUE_DATABASE_NO}" # default localhost:6379
