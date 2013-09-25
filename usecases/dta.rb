class DTA
  include RoomObserver

  attr_reader :domain, :channel_actions

  def initialize(domain)
    @domain = domain
    @channel_actions = 'dta'
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, 'bot', channel_actions \
      or what.downcase.include? 'dta'
      answer_who_is_using_dta(who)
    end
  end

  private
  def answer_who_is_using_dta(person)
    domain.bot_speaks "#{person}: Twoja stara!"
  end
end
