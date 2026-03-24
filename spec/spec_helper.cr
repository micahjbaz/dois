require "spec"
require "../src/*"

alias TE = DoisC::TypeChecking::TypeEngine
alias G = DoisC::Environment::Global
alias VC = DoisC::Environment::VerificationContext
alias AST = DoisC::ASTData
alias T = DoisC::Types