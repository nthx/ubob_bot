require 'yaml'

class PersistenceHex
  def load_usecase_data(db_name, leaderboard)
    data = begin
      YAML.load(File.open(db_name))
    rescue Exception => e
      puts "Could not parse YAML: #{e.message}"
      raise "Database file required: #{db_name}"
    end
    leaderboard.clear
    data.each do |key, value|
      leaderboard[key] = value
    end
  end

  def store_usecase_data(db_name, leaderboard)
    data = {}
    leaderboard.each do |leader, leader_data|
      data[leader] = {:number => 0, :history => {}}
      data[leader][:number] = leaderboard[leader][:number]
    end
    File.open(db_name, "w") {|f| f.write(data.to_yaml) }
  end
end

