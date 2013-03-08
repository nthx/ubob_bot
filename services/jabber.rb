class Jabber

  #public API
  def connect(server, channel)
    puts "Im connecting to a server: #{server} channel: #{channel}"
  end

  def speak(who, what)
    #intentionally empty
    #puts "jabber speaking: #{who}: #{what}"
  end


  private
end

