
class BotMeta
  include RoomObserver

  attr_accessor :domain

  def initialize(domain)
    @domain = domain
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_to what, 'bot' \
       and said_something_not_important what, to_whom
      say_anything(who, to_whom, what, time)
    end
  end



  private
  def said_something_not_important(what, to_whom)
    action = Channel.fetch_action what
     not 'leaderboard help welcome +1 lama bizancjum cow +1s stats'.include? action \
     and not Channel.said_plus_one_to_someone what, to_whom \
     and not Channel.said_minus_to_someone what, to_whom \
     and not Channel.said_plus_one_to_noone what
  end

  def say_anything(who, to_whom, what, time)
    if wants_to_say
      something = pick_something
      domain.bot_speaks "#{to_whom}: #{something}"
    end
  end

  def pick_something
    [
      "Ehh...",
      "I could argue",
      "Im Uncle Bob style, remember?",
      "Not so sure..",
      "Are you?",
      "lol",
      "I find it amusing",
      "I say it's cause of Bizantine Empire",
      "?"
    ].sample
  end

  def wants_to_say
    (Random.rand 10) <= 8
  end
end
