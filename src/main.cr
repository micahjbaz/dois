require "./compilation_error"
require "./ast_data/ast"
require "./parsing/parser"
require "./type_checking/checker"

source_path = "./source.dois"
source_file = File.new(source_path)
source = source_file.gets_to_end
source_file.close




begin
  parser = DoisC::Parsing::Parser.new(source)
  ast = parser.parse


  DoisC::TypeChecking::TypeChecker.new.check(ast)
  puts
  puts " ____ After Type Checker ____"
  # pp ast
rescue parse_error : DoisC::Parsing::ParseError
  puts "#{source_path}:#{parse_error.message}"
  parse_error.put_backtrace
rescue type_error : DoisC::TypeChecking::TypeError
  puts "#{source_path}:#{type_error.to_s}"
  type_error.put_backtrace
end