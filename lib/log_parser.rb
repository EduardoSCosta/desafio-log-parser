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
        players: players_list,
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

  def players_list
    players = []

    players = file_reader.filter_map do |line|
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
    players_hash = players_list.to_h {|player| [player, 0]}
    killer_players = []

    killer_players = file_reader.filter_map do |line|
      line.slice(/[0-9]: \K.*(?= killed )/) if line.include?('Kill:')
    end

    killer_players.delete('<world>')
    killer_players.tally(players_hash)
  end

  def kill_counter
    total_kills = 0

    file_reader.each do |line|
      if line.include?('killed')
        total_kills += 1
      end
    end

    total_kills
  end
end
