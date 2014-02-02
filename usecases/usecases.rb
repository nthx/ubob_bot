require_relative '../domain/helpers'
require_relative './plus_one'
require_relative './plus_one_leaderboard'
require_relative './byzantine'
require_relative './bothering_me'
require_relative './say_welcome'
require_relative './say_cow'
require_relative './say_lama'
require_relative './version'
require_relative './solid'
require_relative './kill_bartek'
require_relative './c_programming'
require_relative './help'
require_relative './dta'

class Usecases
  attr_reader :leaderboard, :usecase_plusone

  def initialize(domain)
    @domain = domain
    @leaderboard = {}

    usecases = []
    running = {}

    usecases << BotWelcome
    usecases << BotLama
    usecases << BotCow
    usecases << BotByzantine
    usecases << BotShowLeaderboard
    usecases << PlusOneLeaderboard
    usecases << BotSolid
    usecases << KillBartek
    usecases << BotHelp
    usecases << BotVersion
    usecases << BotBotheringMe
    usecases << BotCProgramming
    usecases << DTA

    usecases.map do |clazz|
      usecase = clazz.new domain
      running[clazz] = usecase
    end

    validate_usacases_configuration!(running)

    #these need custom setup
    running[BotHelp].setup(running)
    running[BotBotheringMe].setup(running)
    running[PlusOneLeaderboard].setup(@leaderboard)
    running[BotShowLeaderboard].setup(@leaderboard)

    @usecase_plusone = running[PlusOneLeaderboard]
  end

  private
  def validate_usacases_configuration!(usecases)
    usecases.each do |klazz, uc|
      if !uc.respond_to? 'watch_room'
        raise "Error: #{klazz}: must be configured correctly with RoomObserver. See examples"
      end
    end

  end
end
