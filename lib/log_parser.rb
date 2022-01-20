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
      json_file = json_generator(file)
    ensure
      file.close
    end
    json_file
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

  def json_generator(file)
    obj = {@file_path =>
            {
              :lines => log_line_counter(file)
            }
          }
    json_obj = obj.to_json
    json_obj
  end

end
