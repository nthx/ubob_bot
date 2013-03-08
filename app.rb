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

  def apply_glue
    around @domain, :start do |jp, domain, param1, param2|
      @jabber.connect config.jid, config.room, config.password
    end

    around @jabber, :spoken do |jp, jabber, who, what, time|
      @domain.participant_speaks(who, what, time)
    end
  end

  def start
    @domain.start "middleware"
  end
end


app = App.new
app.apply_glue
app.start

#-------------------------------
jabber = app.jabber
jabber.spoken("kuba", "czesc", '')
jabber.spoken("tomek", "hello", '')
jabber.spoken("kuba", "tomek: +1 za to", '')

sleep(999)
