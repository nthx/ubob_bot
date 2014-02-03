#require 'resque'
require 'resque-status'
require_relative '../lib/async_jobs/link_download_job'

REDIS_RESQUE_DATABASE_NO = 8

class LinkDownloaderHex
  def initialize
    validate_redis_resque_ha!
  end


  def download_link(root_dir, room, time, who, url)
    job_id = LinkDownloadJob.create(
      :root_dir => root_dir,
      :room => room,
      :time => time,
      :who => who,
      :url => url
    )
    puts "job created: #{job_id}"
  end

  private
  def validate_redis_resque_ha!
    Resque.redis = "localhost:6379:#{REDIS_RESQUE_DATABASE_NO}" # default localhost:6379
    Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds
  end
end
