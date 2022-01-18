require_relative "./lib/log_parser"

file_parser = LogParser.new("games.log")

puts file_parser.log_reader
