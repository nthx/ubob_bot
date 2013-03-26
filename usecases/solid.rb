#http://www.blackwasp.co.uk/SOLID.aspx
class BotSolid
  include RoomObserver

  attr_reader :domain, :channel_actions, :principles, :verbose

  def initialize(domain)
    @domain = domain
    @verbose = '-v / extra / more'
    @channel_actions = " solid help | solid | solid? | ubob | solid <principle> <#{verbose}>"
    watch_room

    @principles = [
      ['SOLID', 'Single responsibility, Open-closed, Liskov substitution, Interface segregation and Dependency inversion'],
      ['SOLID', 'Is a mnemonic acronym introduced by Michael Feathers for the "first five principles" identified by Robert C. Martin in the early 2000s that stands for five basic principles of object-oriented programming and design.'],
      ['SOLID', 'The principles when applied together intend to make it more likely that a programmer will create a system that is easy to maintain and extend over time.'],
      ['SOLID', "The principles of SOLID are guidelines that can be applied while working on software to remove code smells by causing the programmer to refactor the software's source code until it is both legible and extensible."],
      ['SOLID', 'It is typically used with test-driven development, and is part of an overall strategy of agile and adaptive programming.'],

      ['The Single Responsibility Principle (SRP)', 'A class should have one, and only one, reason to change.'],
      ['The Open Closed Principle (OCP)', 'You should be able to extend a classes behavior, without modifying it.'],
      ['The Liskov Substitution Principle (LSP)', 'Derived classes must be substitutable for their base classes.'],
      ['The Interface Segregation Principle (ISP)', 'Make fine grained interfaces that are client specific.'],
      ['The Dependency Inversion Principle (DIP)', 'Depend on abstractions, not on concretions.'],
      ['The Law of Demeter (LoD)', 'A given object should assume as little as possible about the structure or properties of anything else (including its subcomponents)']
    ]
  end

  def on_say(who, to_whom, what, time)
    return if who == 'bot'
    return if to_whom != 'bot' \
      and not Channel.split_actions(channel_actions).include? what
    return unless Channel.said_action what, channel_actions

    params = Channel.fetch_action_params what
    if params
      if %w'help ?'.include? params
        say_solid_help
      else
        say_solid_principle params.downcase
      end
    else
      say_random_principle
    end
  end

  def say_solid_principle(which)
    principle, principle_extra = if which.start_with? 'solid'
      a = <<-SOLID
The SOLID principles are five dependency management for object oriented programming and design. 
The SOLID acronym was introduced by Robert Cecil Martin, also known as "Uncle Bob".
If you follow the SOLID principles, you can produce code that is more flexible and robust, and that has a higher possibility for reuse.
      SOLID
      b = <<-SOLID
You don't think you know too much already? Give it a bit of time to roll in your mind. Come back later.
      SOLID
      [a, b]

    elsif which.start_with? 'srp'
      a = <<-SRP
The Single Responsibility Principle (SRP) states that there should never be more than one reason for a class to change.
This means that you should design your classes so that each has a single purpose.
This does not mean that each class should have only one method but that all of the members in the class are related to the class's primary function.
Where a class has multiple responsibilities, these should be separated into new classes.
      SRP
      b = <<-SRP
When a class has multiple responsibilities, the likelihood that it will need to be changed increases.
Each time a class is modified the risk of introducing bugs grows.
By concentrating on a single responsibility, this risk is limited.
      SRP
      [a, b]

    elsif which.start_with? 'lsp'
      a = <<-LSP
The Liskov Substitution Principle (LSP) states that "functions that use pointers or references to base classes must be able to use objects of derived classes without knowing it".
When working with languages such as C#, this equates to "code that uses a base class must be able to substitute a subclass without knowing it"
      LSP
      b = <<-LSP
If the type of the dependency must be checked so that behaviour can be modified according to type,
or if subtypes generated unexpected rules or side effects, the code may become more complex, rigid and fragile.
      LSP
      [a, b]

    elsif which.start_with? 'ocp'
      a = <<-OCP
The Open / Closed Principle (OCP) specifies that software entities (classes, modules, functions, etc.) should be open for extension but closed for modification.
The "closed" part of the rule states that once a module has been developed and tested, the code should only be adjusted to correct bugs.
The "open" part says that you should be able to extend existing code in order to introduce new functionality.
      OCP
      b = <<-OCP
As with the SRP, this principle reduces the risk of new errors being introduced by limiting changes to existing code.
      OCP
      [a, b]

    elsif which.start_with? 'isp'
      a = <<-ISP
The Interface Segregation Principle (ISP) specifies that clients should not be forced to depend upon interfaces that they do not use.
This rule means that when one class depends upon another, the number of members in the interface that is visible to the dependent class should be minimised.
      ISP
      b = <<-ISP
Often when you create a class with a large number of methods and properties, the class is used by other types that only require access to one or two members.
The classes are more tightly coupled as the number of members they are aware of grows.
When you follow the ISP, large classes implement multiple smaller interfaces that group functions according to their usage.
The dependents are linked to these for looser coupling, increasing robustness, flexibility and the possibility of reuse.
      ISP
      [a, b]

    elsif which.start_with? 'dip'
      a = <<-DIP
The Dependency Inversion Principle (DIP) is the last of the five rules.
The DIP makes two statements.
The first is that high level modules should not depend upon low level modules.
Both should depend upon abstractions.
The second part of the rule is that abstractions should not depend upon details.
Details should depend upon abstractions.
      DIP
      b = <<-DIP
The DIP primarily relates to the concept of layering within applications,
where lower level modules deal with very detailed functions and higher level modules use lower level classes to achieve larger tasks.
The principle specifies that where dependencies exist between classes, they should be defined using abstractions, such as interfaces, rather than by referencing classes directly.
This reduces fragility caused by changes in low level modules introducing bugs in the higher layers.
The DIP is often met with the use of dependency injection.
      DIP
      [a, b]

    elsif which.start_with? 'lod'
      a = <<-LOD
The Law of Demeter (LoD) or Principle of Least Knowledge.
Can be succinctly summarized in one of the following ways:
 * Each unit should have only limited knowledge about other units: only units "closely" related to the current unit.
 * Each unit should only talk to its friends; don't talk to strangers.
 * Only talk to your immediate friends.
      LOD
      b = <<-LOD
The advantage of following the Law of Demeter is that the resulting software tends to be more maintainable and adaptable.
Since objects are less dependent on the internal structure of other objects, object containers can be changed without reworking their callers.
Disadvantages.. who cares?
      LOD
      [a, b]
    end

    if verbose.split('/').find {|elem| which.strip.include? elem.strip}
      domain.bot_speaks principle_extra
    else
      domain.bot_speaks principle
    end
  end

  def say_solid_help
    domain.bot_speaks('bot: solid [|solid|srp|lsp|ocp|isp|dip|lod] [more|extra|-v]')
  end

  def say_random_principle
    principle = @principles.sample
    domain.bot_speaks(principle[0])
    domain.bot_speaks(principle[1])
  end
end
