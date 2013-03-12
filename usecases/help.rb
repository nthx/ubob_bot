
class BotHelp
  include RoomObserver

  attr_accessor :domain

  def initialize(domain)
    @domain = domain
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, "bot", "help"
      say_help(who, to_whom, what, time)
    end
  end

  def say_help(who, to_whom, what, time)
    domain.bot_speaks "#{to_whom}: welcome, +1 <nick>, leaderboard, cow <text>, cow fortune, lama, <surprise for staszek>"
  end
end
