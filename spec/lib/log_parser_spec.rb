require_relative '../../lib/log_parser'

FIRST_LINE = "  0:00 ------------------------------------------------------------"
RESPONSE = {
  "./spec/fixtures/game_test.log" => {             
    :lines => 159,
    :players => ["Isgalamido","Dono da Bola","Mocinha","Zeh"],
    :kills => {:Isgalamido => 4, :"Dono da Bola" => 0, :Mocinha => 0, :Zeh => 0}
  }
}

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
      it 'return a json with the number of lines, the name of the players and their kills count' do
        file_parser = LogParser.new("./spec/fixtures/game_test.log")
        expect(file_parser.log_file_parser).to eq(RESPONSE.to_json)
      end
    end
  end
end
