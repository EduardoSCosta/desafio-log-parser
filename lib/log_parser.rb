require 'json'

class LogParser
  def initialize(file_path)
    @file_path = file_path
  end

  def first_line_reader
    if File.exist?(@file_path)
      file = File.open(@file_path, "r")
      begin
        first_line = file.readline().chomp
      ensure
        file.close
      end
      first_line
    else
      raise "File not found."
    end
  end

  def log_line_counter(file)
    total_lines = file.readlines().size
    total_lines
  end

  def log_file_parser
    if File.exist?(@file_path)
      file = File.open(@file_path, "r")
      begin
        total_lines = log_line_counter(file)
      ensure
        file.close
      end
      obj = {@file_path =>
              {
                :lines => total_lines
              }
            }
      json_obj = obj.to_json
      json_obj
    else
      raise "File not found."
    end
  end

end
