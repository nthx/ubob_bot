require File.expand_path('../lib/async_jobs/link_download_job.rb', __FILE__)
require 'rake'
require 'resque/tasks'

# this task will get called before resque:pool:setup
# and preload the rails environment in the pool manager
task "resque:setup" do
  # generic worker setup, e.g. Hoptoad for failed jobs
  REDIS_RESQUE_DATABASE_NO = 8
  Resque.redis = "localhost:6379:#{REDIS_RESQUE_DATABASE_NO}" # default localhost:6379
end

task "resque:pool:setup" do
  # close any sockets or files in pool manager
  #ActiveRecord::Base.connection.disconnect!
  # and re-open them in the resque worker parent
  #Resque::Pool.after_prefork do |job|
  #  ActiveRecord::Base.establish_connection
  #end
end

