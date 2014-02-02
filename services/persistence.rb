require 'yaml'
require_relative '../lib/utils_bot'

class PersistenceHex
  def load_usecase_data(room, db_name, leaderboard)
    initialize_db_if_not_exist!(db_name)
    data = load_database(db_name, room)

    leaderboard.clear
    data[:room] = room
    data[:plus_ones].each do |fellow, value|
      leaderboard[fellow] = value
    end
  end

  def store_usecase_data(room, db_name, leaderboard)
    data = {:room => room, :plus_ones => leaderboard}
    File.open(db_name, "w") {|f| f.write(data.to_yaml) }
  end

  private
  def load_database(db_name, room)
    data = nil
    begin
      puts "Loading yml: #{db_name}"
      data = YAML.load(File.open(db_name))
      data = UtilsBot.symbolize_keys!(data)
    rescue Exception => e
      puts "Could not load/parse YAML: #{e.message}"
      raise "Database file required: #{db_name}"
    end
    validate_input_db!(data, room)
    data
  end

  def initialize_db_if_not_exist!(filename)
    return if File.exist? filename
    example = "database_plus_ones.yml.example"
    raise "Provide example database for: #{filename}" if !File.exists? example
    puts "Initializing empty database: #{example} -> #{filename}"
    FileUtils.cp(example, filename)
  end

  def validate_input_db!(data, room)
    if !data[:room] or data[:room] != room
      if data[:room] != '???'#generic name, should be replaced during saving
        raise "Wrong or no room stats: #{room}, actual: #{data[:room]}"
      end
    end
  end
end

