
class Participant
  attr_accessor :name

  def initialize
  end
end

class Room
  attr_accessor :name, :messages

  def initialize(name)
    @name = name
  end

  def speaks(who, what, time)
    #empty
    puts "#{name} #{time}> #{who}: #{what}"
  end
end


class Domain
  def start(room_name)
    puts "started"
    @room = Room.new(room_name)
  end

  def participant_speaks(who, what, time)
    @room.speaks(who, what, time)
  end
end
