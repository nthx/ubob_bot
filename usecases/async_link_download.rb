require 'uri'

class AsyncLinkDownload
  include RoomObserver

  attr_reader :domain

  def initialize(domain)
    @domain = domain
    watch_room
  end

  def user_provided_link(time, who, link)
    #left blank intentionally, for aop
  end

  def on_user_say(who, to_whom, what, time)
    links = extract_links(what)
    if links
      links.each do |link|
        user_provided_link(time, who, link)
      end
    end
  end

  private
  def extract_links(text)
    URI.extract(text, ['http', 'https'])
  end
end
