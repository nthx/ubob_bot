
class BotWelcome
  include RoomObserver

  attr_accessor :domain

  def initialize(domain)
    @domain = domain
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, "bot", "welcome"
      say_welcome(who, to_whom, what, time)
    end
  end

  def say_welcome(who, to_whom, what, time)
    domain.bot_speaks "#{to_whom}: Im just a humble bot by-design-best. Uncle Bob design. Though, not sure if agrees"
  end
end
