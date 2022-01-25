require 'json'

class LogParser
  def initialize(file_path)
    @file_path = file_path
  end

  def first_line_reader
    file = file_opener
    begin
      first_line = file.readline().chomp
    ensure
      file.close
    end
    first_line
  end
  
  def log_file_parser
    json_file = json_generator
    json_file
  end

  private

  def file_opener
    raise "File not found." unless File.exist?(@file_path)

    file = File.open(@file_path, "r")
    file
  end

  def file_reader
    file = file_opener
    begin
      file_lines = file.readlines
    ensure
      file.close
    end
    file_lines
  end

  def log_line_counter
    file_size = file_reader.size
    file_size
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

  def json_generator
    obj = {
      @file_path => {             
        :lines => log_line_counter,
        :players => players_search,
        :kills => each_player_kill,
        :total_kills => kill_counter
      }
    }
    json_obj = obj.to_json
    json_obj
  end

end
