class BotBotheringMe
  include RoomObserver

  attr_reader :domain, :all_channel_actions, :shorter_dialogues, :longer_dialogues

  def initialize(domain)
    @domain = domain
    @all_channel_actions = []
    watch_room

    @shorter_dialogues = [
      "ehh...",
      "I'm Uncle Bob style, remember?",
      "Not so sure..",
      "lol",
      "I'd say it's Byzantine thing",
      "I'd rather die",
      "Ask Pawel on his grandmas :D",
      "eof",
      "use cubi-ruby",
      "?"
    ]
    @longer_dialogues = shorter_dialogues.concat([
      "Are you?",
      "I could argue",
      "take some medicine, might help",
      "I find it amusing"
    ])
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
    return if to_whom != 'bot'
    if said_something_not_important what, to_whom
      say_anything(who, to_whom, what, time)
    end
  end



  private
  def said_something_not_important(what, to_whom)
    action = Channel.fetch_action what

    not all_channel_actions.include? action \
      and not Channel.said_plus_one_to_someone what, to_whom \
      and not Channel.said_minus_to_someone what, to_whom \
      and not Channel.said_plus_one_to_noone what
  end

  def say_anything(who, to_whom, what, time)
    if wants_to_say
      if what.length > 10
        domain.bot_speaks "#{to_whom}: #{pick_for_longer_pokes}"
      else
        domain.bot_speaks "#{to_whom}: #{pick_something}"
      end
    end
  end

  def pick_something
    shorter_dialogues.sample
  end

  def pick_for_longer_pokes
    longer_dialogues.sample
  end

  def wants_to_say
    (Random.rand 10) <= 3
  end
end
