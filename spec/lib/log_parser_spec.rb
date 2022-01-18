require_relative '../../lib/log_parser'

describe '#log_reader' do
  context 'when the file exist' do
    it 'read its first line' do
      file_parser = LogParser.new("./spec/fixtures/game_test.log")
      expect(file_parser.log_reader).to eq("  0:00 ------------------------------------------------------------")
    end
  end

  context 'when the file does not exist' do
    it 'raise a error message' do
      file_parser = LogParser.new("not_game_test.log")
      expect{file_parser.log_reader}.to raise_error("File not found.")
    end
  end
end
