#encoding: utf-8

require 'xmpp4r/client'
require 'xmpp4r/muc'

class JabberHex
  include Jabber
  include Jabber::MUC

  attr_accessor :client, :my_muc

  def initialize
    @when_connected = Time.new
  end

  #public API
  def connect(jid, group_chat, password)
    client_jid = JID::new(jid)
    group_chat_jid = JID.new(group_chat)

    @client = Client::new(client_jid)
    client.connect
    client.auth(password)

    client.on_exception do |e|
      raise e
    end

    client.send(Presence.new.set_type(:available))

    @when_connected = Time.new
    @my_muc = Jabber::MUC::SimpleMUCClient.new(client)
    my_muc.on_message do |time, sender, text| 
      if not still_connecting
        if !!time
          spoken(sender, text, time)
        else
          #unfortunately misconfigured servers do not send time
          time = Time.new
          spoken(sender, text, time)
          #spoken_from_history(sender, text, time)
        end
      end
    end
    my_muc.on_private_message do |time, sender, text| 
      if not still_connecting
        private_message_to_bot(sender, text, time)
      end
    end
    my_muc.join(group_chat_jid)
  end

  def spoken(who, what, time)
    #intentionally empty
  end

  def spoken_from_history(who, what, time)
    #intentionally empty
  end

  def private_message_to_bot(who, what, time)
    #intentionally empty
  end

  def groupchat_msg(what)
    return if still_connecting
    my_muc.say what
  end

  private
  def private_msg(whom, what)
    msg = Message::new("tomekn@jabber", "Hello... John? #{Time.new}")
    msg.type=:chat
    client.send(msg)
  end

  # Give 5 secs to read history messages Jabber sends when connecting
  # I don't want to parse them again, as they're duplicates
  def still_connecting
    warmup=3
    now = Time.new
    (now - @when_connected).to_i <= warmup
  end

end

