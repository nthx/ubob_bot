
class PlusOneLeaderboard
  include RoomObserver

  attr_accessor :domain, :leaderboard

  def initialize(domain, usecases)
    @domain = domain
    @leaderboard = usecases.leaderboard
    watch_room
  end

  def on_say(who, to_whom, what, time)
    if Channel.said_plus_one_to_noone what \
      and who != 'bot'
      say_unsure
    end

    if Channel.said_plus_one_to_someone what, to_whom
      remember(who, to_whom, what, time)

    elsif Channel.said_minus_to_someone what, to_whom
      elaborate_on_minus who
    end
  end

  def remember(who, to_whom, what, time)
    setup_leaderboard_for to_whom
    if not plusone_stored?(to_whom, who, what, time)
      store_plusone_for(to_whom, who, what, time)
    end
  end

  def store_plusone_for(to_whom, who, what, time)
    history_key = history_key(who, what, time)
    history_value = {:what => what, :time => time, :who => who}
    leaderboard[to_whom][:number] += 1
    leaderboard[to_whom][:history][history_key] = history_value
    domain.bot_speaks "#{who} gave +1 to #{to_whom}"
  end

  private
  def say_unsure
    domain.bot_speaks "bit guessing what you're doing.. you have to give me more"
  end

  def elaborate_on_minus(who)
    domain.bot_speaks "#{who}: pure evil you :E"
  end

  def setup_leaderboard_for(to_whom)
    if not leaderboard.include? to_whom
      leaderboard[to_whom] = {:number => 0, :history => {}}
    end
  end

  def plusone_stored?(to_whom, who, what, time)
    key = history_key(who, what, time)
    leaderboard[to_whom][:history].include? key
  end

  def history_key(who, what, time)
    "#{time};#{who};#{what}"
  end
end
