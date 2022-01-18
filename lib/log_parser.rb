class LogParser
  def initialize(file_path)
    @file_path = file_path
  end

  def log_reader
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

end
