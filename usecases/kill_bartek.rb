
class KillBartek
  include RoomObserver

  attr_reader :domain, :channel_actions, :kills

  def initialize(domain)
    @domain = domain
    @channel_actions = 'bartek'
    watch_room

    @kills = [
      "(eval):14:in `bucket_attribute' - and be happy .. not, when traceback is needed to actualy fucking TRACE",
      "eval \"StbApiV#{@version} - and be happy Im a hacker",
      "return url if url =~ %r(^https?://) - and be happy why the fuck someone includes https in database query",
      "products['products'].first.should match /\#{@service.id} - and be happy 4500 chars long xml includes digit 1/"
    ]
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, 'bot', channel_actions \
      or what.downcase.include? 'bartek' \
      or what.downcase.include? 'bartk'
      say_any_method_of_killing_bartek
    end
  end



  private
  def say_any_method_of_killing_bartek
    domain.bot_speaks "I'd kill bartek 4: #{kills.sample}"
  end
end