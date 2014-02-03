require './domain/helpers'
require './domain/domain'
require './usecases/usecases'
require './services/jabber'
require './services/persistence'
require_relative 'services/link_downloader'
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
    @link_downloader = LinkDownloaderHex.new
    @persistence = PersistenceHex.new
  end

  def apply_domain_glue
    after @domain, :domain_starts do |jp, domain, param1, param2|
      @jabber.connect(config.jid, config.group_chat, config.password)
    end

    after @domain, :bot_speaks do |jp, domain, what|
      @jabber.groupchat_msg(what)
    end

    after @jabber, :spoken do |jp, jabber, who, what, time|
      puts "> #{time} #{who}: \"#{what}\""
      @domain.participant_speaks(who, what, time)
    end
  end

  def start_usecases
    @usecases = Usecases.new(@domain, @config)
  end

  def apply_usecases_glue
    before @domain, :domain_starts do |jp, domain|
      @persistence.load_usecase_data(@config.room, @config.db_plus_one, @usecases.leaderboard)
    end
    after @usecases.usecase_plusone, :remember do |jp, usecase_plusone|
      @persistence.store_usecase_data(@config.room, @config.db_plus_one, @usecases.leaderboard)
    end

    after @usecases.usecase_async_link_download, :user_provided_link do |jp, usecase, time, who, link|
      @link_downloader.download_link(@config.room, time, who, link)
    end
  end

  def start_app
    @domain.domain_starts(@config.room)
    puts "App started."
  end
end


app = App.new
app.apply_domain_glue
app.start_usecases
app.apply_usecases_glue
app.start_app

#Example calls
jabber = app.jabber
#jabber.spoken("michal", "bot: welcome", Time.new)
#jabber.spoken("kuba", "tomek: +1", Time.new)
#jabber.spoken("kuba", "bot: leaderboard", Time.new)
#jabber.spoken("kuba", "bot: solid", Time.new)

#Go to endless "loop" - have no idea how to do different way
sleep(9999999999)
