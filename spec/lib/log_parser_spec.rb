require_relative '../../lib/log_parser'

describe '#first_line_reader' do
  context 'when the file exist' do
    it 'read its first line' do
      file_parser = LogParser.new("./spec/fixtures/game_test.log")
      expect(file_parser.first_line_reader).to eq("  0:00 ------------------------------------------------------------")
    end
  end

  context 'when the file does not exist' do
    it 'raise a error message' do
      file_parser = LogParser.new("not_game_test.log")
      expect{file_parser.first_line_reader}.to raise_error("File not found.")
    end
  end
  
end

describe '#log_file_parser' do
  context 'when the file exist' do
    it 'read its total number of lines' do
      file_parser = LogParser.new("./spec/fixtures/game_test.log")
      expect(file_parser.log_file_parser).to eq("{\"./spec/fixtures/game_test.log\":{\"lines\":159}}")
    end
  end
end
