require './domain/helpers'
require './domain/domain'
require './usecases/usecases'
require './services/jabber'
require './services/persistence'
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
    @persistence = PersistenceHex.new
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

  def initialize_usecases
    @usecases = Usecases.new @domain
  end

  def apply_usecases_glue
    before @domain, :start do |jp, domain|
      @persistence.load_usecase_data @usecases.leaderboard
    end
    after @usecases.plusone, :remember do |jp, plusone|
      @persistence.store_usecase_data @usecases.leaderboard
    end
  end

  def start
    @domain.start "middleware"
  end
end


app = App.new
app.apply_domain_glue
app.initialize_usecases
app.apply_usecases_glue
app.start

#Example calls
jabber = app.jabber
#jabber.spoken("michal", "bot: welcome", Time.new)
#jabber.spoken("kuba", "tomek: +1", Time.new)
#jabber.spoken("kuba", "bot: leaderboard", Time.new)
#jabber.spoken("kuba", "bot: solid", Time.new)

sleep(99999)
