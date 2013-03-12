
class BotLama
  include RoomObserver

  attr_accessor :domain

  def initialize(domain)
    @domain = domain
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, 'bot', 'lama'
      draw_lama(who, what, time)
    end
  end

  def draw_lama(who, what, time)
    domain.bot_speaks " _"
    domain.bot_speaks "/ \\"
    domain.bot_speaks "|..|"
    domain.bot_speaks "  * "
    domain.bot_speaks "  /|"
  end
end
