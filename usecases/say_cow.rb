require 'open3'
require 'shellwords'

class BotCow
  include RoomObserver

  attr_accessor :domain

  def initialize(domain)
    @domain = domain
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, "bot", "cow"
      draw_cow(who, what, time)
    end
  end

  def draw_cow(who, what, time)
    params = Channel.fetch_action_params what
    params = Shellwords.escape params
    cmd = "cowsay #{params}"
    if params == 'fortune'
      cmd = 'fortune | cowsay'
    end
    stdin, stdout, stderr = Open3.popen3(cmd)
    stdout.readlines.each do |x|
      t = x.gsub "\n", ''
      domain.bot_speaks t
      puts t
    end
  end
end
