class BotHelp
  include RoomObserver

  attr_reader :domain, :all_channel_actions, :channel_actions

  def initialize(domain)
    @domain = domain
    @all_channel_actions = []
    @channel_actions = 'help | ?'
    watch_room
  end

  def setup(running_usecases)
    running_usecases.each do |clazz, usecase|
      if usecase.respond_to? :channel_actions
        all_channel_actions.concat Channel.split_actions(usecase.channel_actions)
      end
    end
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, "bot", channel_actions
      say_help(who, to_whom, what, time)
    end
  end

  def say_help(who, to_whom, what, time)
    domain.bot_speaks "#{to_whom}: #{all_channel_actions.sort.join(', ')}"
  end
end
