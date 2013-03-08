require 'xmpp4r/client'
require 'xmpp4r/muc'

class JabberHex
  include Jabber
  include Jabber::MUC

  #public API
  def connect(jid, room, password)
    puts "Im connecting to a server: #{jid} room: #{room}"
    client_jid = JID::new(jid)
    room_jid = JID.new(room)

    client = Client::new(client_jid)
    client.connect
    client.auth(password)

    client.on_exception do 
      raise "OMG! Exception happened"
    end

    client.send(Presence.new.set_type(:available))

    my_muc = Jabber::MUC::SimpleMUCClient.new(client)
    my_muc.on_message do |time, sender, text| 
      spoken(sender, text, time)
    end
    my_muc.join(room_jid)
  end

  def spoken(who, what, time)
    #intentionally empty
    #puts "jabber speaking: #{who}: #{what}"
  end


  private
  def private_msg(client, whom, what)
    msg = Message::new("tomekn@jabber", "Hello... John? #{Time.new}")
    msg.type=:chat
    client.send(msg)
  end

  def groupchat_msg(client, what)
    client.say "pieknie"
  end
end

