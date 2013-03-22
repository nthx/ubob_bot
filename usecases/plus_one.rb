class PlusOneLeaderboard
  include RoomObserver

  attr_reader :domain, :leaderboard, :channel_actions

  def initialize(domain)
    @domain = domain
    @channel_actions = '+1 | -1'
    watch_room
  end

  def setup(leaderboard)
    @leaderboard = leaderboard
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_plus_one_to_noone what
      say_unsure
    end

    if Channel.said_plus_one_to_someone what, to_whom
      if who == to_whom
        say_no_no_to_myself(who)
      else
        remember(who, to_whom, what, time)
      end

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

  def say_no_no_to_myself(who)
    domain.bot_speaks "#{who}: I'm an intelligent bot"
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
