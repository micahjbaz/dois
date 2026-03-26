require "spec"
require "../src/**"

def source_location(l : Int = 0, c : Int = 0)
  AST::SourceLocation.new(l, c)
end

def parse(source : String)
  DoisC::Parsing::Parser.new(source).parse
end

def expect_parse_error(source : String)
  expect_raises(DoisC::Parsing::ParseError) { parse(source) }
end

def check(source : String)
  ast = parse(source)
  DoisC::TypeChecking::TypeChecker.new.check(ast)
end

def expect_type_error(source : String)
  expect_raises(DoisC::TypeChecking::TypeError) { check(source) }
end


alias TE = DoisC::TypeChecking::TypeEngine
alias G = DoisC::Environment::Global
alias VC = DoisC::Environment::VerificationContext
alias AST = DoisC::ASTData
alias T = DoisC::Types