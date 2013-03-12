#http://www.blackwasp.co.uk/SOLID.aspx
class BotSolid
  include RoomObserver

  attr_accessor :domain, :principles

  def initialize(domain)
    @domain = domain
    watch_room

    @principles = [
      ['The Single Responsibility Principle (SRP)', 'A class should have one, and only one, reason to change.'],
      ['The Open Closed Principle (OCP)', 'You should be able to extend a classes behavior, without modifying it.'],
      ['The Liskov Substitution Principle (LSP)', 'Derived classes must be substitutable for their base classes.'],
      ['The Interface Segregation Principle (ISP)', 'Make fine grained interfaces that are client specific.'],
      ['The Dependency Inversion Principle (DIP)', 'Depend on abstractions, not on concretions.']
    ]
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    if Channel.said_action_to what, 'bot', 'solid'
      say_solid_principle(who, what, time)
    end
  end

  def say_solid_principle(who, what, time)
    principle = @principles.sample
    domain.bot_speaks("SOLID principle: #{principle[0]}")
    domain.bot_speaks(principle[1])

  end
end
