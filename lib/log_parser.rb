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

  def json_generator
    obj = {
      @file_path => {             
        :lines => log_line_counter,
        :players => players_search
      }
    }
    json_obj = obj.to_json
    json_obj
  end

end
