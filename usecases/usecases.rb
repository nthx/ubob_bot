require_relative '../domain/helpers'
require_relative './plus_one'
require_relative './plus_one_leaderboard'
require_relative './byzantine'
require_relative './bothering_me'
require_relative './say_welcome'
require_relative './say_cow'
require_relative './say_lama'

class Usecases
  attr_accessor :leaderboard, :domain, :plusone

  def initialize(domain)
    @domain = domain
    @leaderboard = {}

    BotWelcome.new domain
    BotLama.new domain
    BotCow.new domain
    #BotByzantine.new domain
    BotShowLeaderboard.new domain, self
    @plusone = PlusOneLeaderboard.new domain, self
    BotMeta.new domain
  end
end



