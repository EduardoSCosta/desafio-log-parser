require 'json'

class LogParser
  def initialize(file_path)
    @file_path = file_path
  end

  def first_line_reader
    file_reader[0].chomp
  end
  
  def log_file_parser
    obj = {
      @file_path => {             
        lines: log_line_counter,
        players: players_search,
        kills: each_player_kill,
        total_kills: kill_counter
      }
    }

    obj.to_json
  end

  private

  def file_reader
    raise "File not found." unless File.exist?(@file_path)

    File.readlines(@file_path)
  end

  def log_line_counter
    file_reader.size
  end

  def players_search
    file_lines = file_reader
    players = []

    file_lines.each do |line|
      if line.include?('Kill:')
        players << line.slice(/[0-9]: \K.*(?= kil)/)
        players << line.slice(/d \K.*(?= b)/)
      elsif line.include?('ClientUserinfoChanged')
        players << line.slice(/[0-9] n\\\K.*(?=(\\t\\[0-9]))/)
      end
    end

    players.uniq!
    players.delete('<world>')
    players
  end

  def each_player_kill
    file_lines = file_reader
    players_list = players_search
    players_hash = {}

    players_list.each do |item|
      players_hash[item] = 0    
    end

    file_lines.each do |line|
      players_hash.each do |item, value|
        if line.include?("#{item} killed")
          players_hash[item] = value + 1          
        end
      end
    end

    players_hash
  end

  def kill_counter
    file_lines = file_reader
    total_kills = 0

    file_lines.each do |line|
      if line.include?('killed')
        total_kills += 1
      end
    end

    total_kills
  end

end
