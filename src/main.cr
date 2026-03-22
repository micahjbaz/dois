require "./compilation_error"
require "./ast_data/ast"
require "./parsing/parser"
require "./type_checking/checker"
require "colorize"

source_path = "./source.dois"
source_file = File.new(source_path)
source = source_file.gets_to_end
source_file.close




begin
  parser = DoisC::Parsing::Parser.new(source)

  puts "Parsing #{source_path}...".colorize(100, 100, 100)
  ast = parser.parse
  puts "Parsed successfully!".colorize(100, 200, 100)

  puts

  puts "Type checking #{source_path}...".colorize(100, 100, 100)
  DoisC::TypeChecking::TypeChecker.new.check(ast)
  puts "Type checked successfully!".colorize(100, 200, 100)

rescue parse_error : DoisC::Parsing::ParseError
  puts "#{source_path}:#{parse_error.message}".colorize(220, 150, 150)
  # parse_error.put_backtrace
rescue type_error : DoisC::TypeChecking::TypeError
  puts "#{source_path}:#{type_error.to_s}".colorize(220, 150, 150)
  # type_error.put_backtrace
end