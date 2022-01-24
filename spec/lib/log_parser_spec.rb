require_relative '../../lib/log_parser'

FIRST_LINE = "  0:00 ------------------------------------------------------------"
JSON_RESPONSE = "{\"./spec/fixtures/game_test.log\":{\"lines\":159,\"players\":[\"Isgalamido\",\"Dono da Bola\",\"Mocinha\",\"Zeh\"]}}"

describe LogParser do
  describe '#first_line_reader' do
    context 'when the file exist' do
      it 'read its first line' do
        file_parser = LogParser.new("./spec/fixtures/game_test.log")
        expect(file_parser.first_line_reader).to eq(FIRST_LINE)
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
      it 'read its total number of lines and print the name of the players' do
        file_parser = LogParser.new("./spec/fixtures/game_test.log")
        expect(file_parser.log_file_parser).to eq(JSON_RESPONSE)
      end
    end
  end
end
