
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

  def speaks(participant, what)
    #empty
    puts "room: #{name} #{participant} spoken #{what}"
  end


end


class Domain
  def start(room_name)
    puts "started"
    @room = Room.new(room_name)
  end

  def participant_speaks(participant, what)
    @room.speaks(participant, what)
  end
end
