class BotShowLeaderboard
  include RoomObserver

  attr_reader :domain, :leaderboard, :channel_actions

  def initialize(domain)
    @domain = domain
    @channel_actions = 'leaderboard | stats'
    watch_room
  end

  def setup(leaderboard)
    @leaderboard = leaderboard
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, "bot", channel_actions
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
      to_speak.each {|x| domain.bot_speaks x}
    else
      domain.bot_speaks "not yet my man, not yet.."
    end
  end
end
