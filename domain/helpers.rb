require './lib/aquarium_helper'
include AquariumHelper

module RoomObserver
  def watch_room
    after domain, :someone_spoken_in_room do |jp, domain, *args|
      err_msg = "had a nil when it didn't expected"
      begin
        who, to_whom, what, time = *args
        on_say(*args)
      rescue Exception => e
        if !what.include? err_msg #not to go into infinite loop
          domain.bot_speaks "#{self.class.name}: #{err_msg}"
        end
        puts "#{self.class.name}: #{e}"
      end
    end
  end
end

class Channel
  def self.said_action(what, actions)
    actions = split_actions_remove_params(actions)
    actual_action = fetch_action what
    actions.include? actual_action.downcase
  end

  def self.said_action_to(what, to_whom, actions)
    return false if not said_to what, to_whom
    said_action what, actions
  end

  def self.split_actions(actions)
    if actions.is_a? String
      if actions.include? '|'
        actions.split('|').map {|x| x.strip }
      else
        actions.split
      end
    else
      actions
    end
  end

  def self.split_actions_remove_params(actions)
    if actions.is_a? String
      if actions.include? '|'
        actions.gsub(/<.*>/, '').split('|').map {|x| x.strip }
      else
        actions.split
      end
    else
      actions
    end
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
    what.include? "+1" and not receivier
  end


  def self.said_minus_to_someone(what, to_whom)
    return unless to_whom
    action = fetch_action what
    action and action.length >= 2 and action[0] == '-' and action[1].to_i > 0
  end

  def self.fetch_action(what)
    chunked = what.split.map {|x| x.strip}
    return nil if chunked.length == 0
    if chunked.length == 1
      chunked[0]
    else
      chunked[1]
    end
  end

  def self.fetch_action_params(what)
    chunked = what.split.map {|x| x.strip}
    return nil if chunked.length <= 2
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
