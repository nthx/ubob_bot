require 'open3'
require 'shellwords'

class BotCow
  include RoomObserver

  attr_reader :domain, :channel_actions

  def initialize(domain)
    @domain = domain
    @channel_actions = 'cow <what> | cow fortune | fortune'
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, "bot", channel_actions
      draw_cow(what)
    end
  end

  def draw_cow(what)
    action = Channel.fetch_action what
    params = Channel.fetch_action_params what
    cmd = 'uname'

    if action == 'fortune'
      cmd = 'fortune'
      params = nil
    elsif action == 'cow' and params == 'fortune'
      cmd = 'fortune | /usr/games/cowsay'
      params = nil
    elsif action == 'cow' and params
      cmd = "/usr/games/cowsay"
      params = params
    end

    out = run_drawing_process(cmd, params)
    out.each {|t| domain.bot_speaks t}
  end

  private
  def run_drawing_process(cmd, params)
    if params
      cmd = "#{cmd} #{Shellwords.escape(params)}"
    end
    puts "#{cmd}"
    stdin, stdout, stderr = Open3.popen3(cmd)
    stdout.readlines.map do |t|
      t.gsub "\n", ''
    end
  end
end
