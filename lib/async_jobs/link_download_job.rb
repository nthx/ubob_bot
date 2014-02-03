require 'resque-status'
require 'securerandom'
require 'uri'
require 'mechanize'

class LinkDownloadJob
  include Resque::Plugins::Status

  @queue = 'high'

  def perform
    filename = generate_filename(
        options['root_dir'], options['room'],
        options['time'],
        options['who'], options['url'])
    download(options['url'], filename)
    #
    #num = 0
    #total = 100
    #at(num, total, "At #{num} of #{total}")
    #`date >> /tmp/job-link-download.txt`
  end

  def download(url, filename)
    agent = Mechanize.new
    page = agent.get(url)
    ext = mechanize_file(page)
    file = "#{filename}-#{ext}"
    File.open(file, "w") do |f|
      f.write(page.body)
    end
  end

  #def download_v2(url, dir, filename)
  #  require 'open-uri'
  #
  #  file = File.join(dir, "#{filename}")
  #  File.open(file, "wb") do |saved_file|
  #    # the following "open" is provided by open-uri
  #    open(url, "rb") do |read_file|
  #      saved_file.write(read_file.read)
  #    end
  #  end
  #end

  private
  def generate_filename(root_dir, room, time, who, url)
    dir = File.join(root_dir, room, time.to_s[0..9])
    FileUtils.mkdir_p(dir)

    uuid = SecureRandom.uuid.to_s[0..12]
    File.join(dir, "#{who}-#{uuid}")
  end

  def mechanize_file(page)
    file = page.filename[0..40]
    if page.is_a? Mechanize::Image
      "#{file}.jpg"
    else
      "#{file}.html"
    end
  end

end
