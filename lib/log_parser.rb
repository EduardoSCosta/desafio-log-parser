class LogParser
  def initialize(file_path)
    @file_path = file_path
  end

  def log_reader
    if(File.exist?(@file_path))
      @file = File.open(@file_path, "r")
      puts @file.readlines()[0]
      @file.close
    else
      raise "File not found."
    end
  end

end