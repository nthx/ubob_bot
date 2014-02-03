##
#  This implementation is not "hex" friendly. See "AsyncLinkDownloader" for
#  better separation
#
class StoreTalkArchive
  include RoomObserver

  attr_reader :domain

  def initialize(domain)
    @domain = domain
    @room = nil
    @filename = nil
    watch_room
  end

  def setup(room)
    @room = room
    @filename = "#{room}-database_talk_archive.yml"
    on_say("StoreTalkArchive", "", 'session starts', Time.now.utc)
  end

  def on_say(who, to_whom, what, time)
    archive = "#{@room}: #{time}: #{who}: #{what}\n"

    #impl below is correct, but should be split into "hex"
    store!(archive)
  end

  private
  def store!(msg)
    File.open(@filename, 'a') { |f| f.write(msg) }
  end
end
