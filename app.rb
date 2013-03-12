require './domain/helpers'
require './domain/domain'
require './usecases/usecases'
require './services/jabber'
require './configuration/settings'
require './lib/aquarium_helper'

include AquariumHelper

class App

  attr_accessor :config
  attr_accessor :domain, :jabber

  def initialize
    @config = Settings.new
    @domain = Domain.new
    @jabber = JabberHex.new
  end

  def initialize_usecases
    @usecases = Usecases.new @domain
    @usecases.start
  end

  def apply_domain_glue
    after @domain, :start do |jp, domain, param1, param2|
      @jabber.connect config.jid, config.room, config.password
    end

    after @domain, :bot_speaks do |jp, domain, what|
      @jabber.groupchat_msg(what)
    end

    after @jabber, :spoken do |jp, jabber, who, what, time|
      @domain.participant_speaks(who, what, time)
    end
  end

  def start
    @domain.start "middleware"
  end
end


app = App.new
app.apply_domain_glue
app.initialize_usecases
app.start

#-------------------------------
jabber = app.jabber
#jabber.spoken("michal", "bot: hello", Time.new)
jabber.spoken("michal", "bot: welcome", Time.new)
#jabber.spoken("kuba", "hello", Time.new)
#jabber.spoken("tomek", "hello", Time.new)
#jabber.spoken("kuba", "tomek: +1", Time.new)
#jabber.spoken("kuba", "tomek: +1 Y", Time.new)
jabber.spoken("kuba", "tomek: +1 Z", Time.new)
#jabber.spoken("kuba", "tomek: +1 Z", Time.new)
#jabber.spoken("tomek", "kuba: +1 thanks", Time.new)
#jabber.spoken("wladek", "jurij: +1", Time.new)
#jabber.spoken("wladek", "wladyslaw: +1", Time.new)
#jabber.spoken("tomek", "wladyslaw: +1 2u2", Time.new)
#jabber.spoken("michal", "bot: leaderboard", Time.new)
#jabber.spoken("michal", "bot: cool", Time.new)
#jabber.spoken("michal", "bot: cool", Time.new)
#jabber.spoken("michal", "bot: cool", Time.new)
#jabber.spoken("michal", "bot: cool", Time.new)
#jabber.spoken("michal", "bot: cool", Time.new)
#jabber.spoken("michal", "bot: cool", Time.new)

sleep(99999)
