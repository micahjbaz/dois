require "./compilation_error"
require "./ast_data/ast"
require "./parsing/parser"
require "./type_checking/checker"
require "colorize"
require "./codegen/transpiler"


source_path = nil

args = ARGV.dup
idx = 0
while idx < args.size
  source_path ||= args[idx]
  idx += 1
end

if source_path.nil? || source_path.strip.empty?
  puts "Usage: doisc <source_file>"
  exit(1)
end

source_path = source_path.strip
source = File.read(source_path)
c_output_path = "./out.c"




begin
  parser = DoisC::Parsing::Parser.new(source)

  puts "Parsing #{source_path}...".colorize(100, 100, 100)
  ast = parser.parse
  puts "Parsed successfully!".colorize(100, 200, 100)

  puts

  puts "Type checking #{source_path}...".colorize(100, 100, 100)
  DoisC::TypeChecking::TypeChecker.new.check(ast)
  puts "Type checked successfully!".colorize(100, 200, 100)

  puts

  puts "Generating C #{source_path}...".colorize(100, 100, 100)
  generated_c = DoisC::Codegen::Transpiler.new.transpile(ast)
  File.write(c_output_path, generated_c)
  puts "Generated C successfully -> #{c_output_path}".colorize(100, 200, 100)


rescue parse_error : DoisC::Parsing::ParseError
  puts "#{source_path}:#{parse_error.message}".colorize(220, 150, 150)
  parse_error.put_backtrace
rescue type_error : DoisC::TypeChecking::TypeError
  puts "#{source_path}:#{type_error.to_s}".colorize(220, 150, 150)
  type_error.put_backtrace
end