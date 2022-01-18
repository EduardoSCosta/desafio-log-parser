require_relative "./lib/log_parser"

file_parser = LogParser.new("games.log")

puts file_parser.first_line_reader

puts file_parser.log_file_parser