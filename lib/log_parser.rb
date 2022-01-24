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

  def json_generator
    obj = {
      @file_path => {             
        :lines => log_line_counter
      }
    }
    json_obj = obj.to_json
    json_obj
  end

end
