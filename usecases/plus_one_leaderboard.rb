
class BotShowLeaderboard
  include RoomObserver

  attr_accessor :domain, :leaderboard

  def initialize(domain, usecases)
    @domain = domain
    @leaderboard = usecases.leaderboard
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, "bot", "leaderboard" \
       or Channel.said_action_to what, "bot", "stats" \
       or Channel.said_action_to what, "bot", "+1s"
      show_leaderboard(who, what, time)
    end
  end

  def show_leaderboard(who, what, time)
    to_speak = []
    sorted = leaderboard.sort_by {|leader, data| -1 * data[:number]}
    sorted.each do |leader, data|
      to_speak << "  #{leader}: #{leaderboard[leader][:number]}"
    end

    if to_speak.length > 0
      domain.bot_speaks "+1 (tm) Leader Board"
      to_speak.each {|x| domain.bot_speaks x}
    else
      domain.bot_speaks "not yet my man, not yet.."
    end
  end
end
