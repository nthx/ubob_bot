class BotVersion
  include RoomObserver

  attr_reader :domain, :channel_actions

  def initialize(domain)
    @domain = domain
    @channel_actions = 'version | -v'
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, "bot", channel_actions
      say_version
    end
  end

  def say_version
    version = []
    version << RUBY_PLATFORM
    version << RUBY_VERSION
    version << ENV['rvm_ruby_string']
    domain.bot_speaks version.join ' '
  end
end

