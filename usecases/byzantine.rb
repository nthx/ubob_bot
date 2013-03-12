class BotByzantine
  include RoomObserver

  attr_reader :domain, :channel_actions

  def initialize(domain)
    @domain = domain
    @data = prepare_data
    @channel_actions = 'bizancjum'
    watch_room
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, "bot", channel_actions \
       or what.downcase.include? "bizan"
      say_something_on_byzantine(who, what, time)
    end
  end

  def say_something_on_byzantine(who, what, time)
    if wants_to_say
      on_byzantine = find_sth_on_byzantine
      domain.bot_speaks "#{who}: #{on_byzantine}"
    end
  end

  private
  def wants_to_say
    (Random.rand 10) <= 3
  end

  def prepare_data
    require 'hpricot'
    require 'open-uri'
    url = 'http://pl.wikipedia.org/wiki/Cesarstwo_Bizanty%C5%84skie'
    data = open(url).read
    data.force_encoding('UTF-8').encode!('UTF-8')
    doc = Hpricot::XML(data)
    doc.search "div#bodyContent p"
  end

  def find_sth_on_byzantine
    para = @data.sample.to_s
    text = para.gsub(/<\/?[^>]*>/, '').gsub(/\n\n+/, "\n").gsub(/^\n|\n$/, '')
    text
  end
end
