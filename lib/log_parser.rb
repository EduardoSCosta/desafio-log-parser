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
    json_generator
  end

  private

  def file_opener
    raise "File not found." unless File.exist?(@file_path)

    File.open(@file_path, "r")
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

    players = file_lines.filter_map do |line|
      if line.include?('Kill:')
        [line.slice(/[0-9]: \K.*(?= killed )/),
        line.slice(/killed \K.*(?= by )/)]
      elsif line.include?('ClientUserinfoChanged')
        line.slice(/[0-9] n\\\K.*(?=(\\t\\[0-9]))/)
      end
    end

    players.flatten!.uniq!.delete('<world>')
    players
  end

  def each_player_kill
    file_lines = file_reader
    players_list = players_search

    players_hash = players_list.to_h {|player| [player, 0]}

    file_lines.each do |line|
      players_hash.each do |player_name, player_kills|
        if line.include?("#{player_name} killed")
          players_hash[player_name] = player_kills + 1
        elsif line.include?("<world> killed #{player_name}")
          players_hash[player_name] = player_kills - 1
        end
      end
    end

    players_hash
  end

  def kill_counter
    file_lines = file_reader
    file_lines.select {|line| line.include?('killed')}.size
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
    obj.to_json
  end

end
