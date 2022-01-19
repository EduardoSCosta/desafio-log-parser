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
    file = file_opener
    begin
      total_lines = log_line_counter(file)
    ensure
      file.close
    end
    json_generator(total_lines)
  end

  private

  def file_opener
    if File.exist?(@file_path)
      file = File.open(@file_path, "r")
      file
    else
      raise "File not found."
    end
  end

  def log_line_counter(file)
    total_lines = file.readlines().size
    total_lines
  end

  def json_generator(total_lines)
    obj = {@file_path =>
            {
              :lines => total_lines
            }
          }
    json_obj = obj.to_json
    json_obj
  end

end
