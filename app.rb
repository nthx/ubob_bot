require './domain/domain'
require './usecases/usecases'
require './services/jabber'
require './lib/aquarium_helper'

include AquariumHelper

class App

  attr_accessor :domain, :jabber

  def initialize
    @domain = Domain.new
    @jabber = Jabber.new
  end

  def apply_glue
    around @domain, :start do |jp, domain, param1, param2|
      @jabber.connect "cw", "middleware"
    end

    around @jabber, :speak do |jp, jabber, who, what|
      @domain.participant_speaks(who, what)
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
jabber.speak("kuba", "czesc")
jabber.speak("tomek", "hello")
jabber.speak("kuba", "tomek: +1 za to")

#expect... domain...
