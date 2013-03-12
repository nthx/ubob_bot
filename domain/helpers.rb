require './lib/aquarium_helper'
include AquariumHelper

module RoomObserver
  def watch_room
    after domain, :someone_spoken_in_room do |jp, domain, *args|
      begin
        on_say(*args)
      rescue Exception => e
        domain.bot_speaks "I had a nil when I didnt expected"
        puts e
      end
    end
  end
end

class Channel
  def self.said_action_to(what, to_whom, action)
    return if not said_to what, to_whom
    actual_action = fetch_action what
    actual_action == action
  end

  def self.said_to(what, to_whom)
    receivier = fetch_receivier what
    to_whom == receivier
  end

  def self.said_plus_one_to_someone(what, to_whom)
    return unless to_whom
    action = fetch_action what
    action and \
      action.start_with? "+" \
      and action.length >=2 \
      and action[1].to_i >= 1
  end

  def self.said_plus_one_to_noone(what)
    receivier = fetch_receivier what
    what.start_with? "+1" and not receivier
  end


  def self.said_minus_to_someone(what, to_whom)
    return unless to_whom
    action = fetch_action what
    action and action.length >= 2 and action[0] == '-' and action[1].to_i > 0
  end

  def self.fetch_action(what)
    chunked = what.split.map {|x| x.strip}
    return nil unless chunked.length > 0
    action = chunked[1]
  end

  def self.fetch_action_params(what)
    chunked = what.split.map {|x| x.strip}
    return nil unless chunked.length > 0
    action = chunked[2..chunked.length].join ' '
  end

  def self.fetch_receivier(what)
    chunked = what.strip.split.map {|x| x.strip}
    return nil unless chunked.length > 0
    nick = chunked[0]
    return nil unless (nick.end_with? ':' or nick.end_with? ',')
    nick[0..nick.length-2]
  end
end
