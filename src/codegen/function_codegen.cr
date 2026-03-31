

module DoisC
  module Codegen
    class FunctionCodegen
      def initialize(@type_codegen : TypeCodegen, @expression_codegen : ExpressionCodegen, @io : IO::Memory)
      end

      def emit_function(fn : ASTData::FunctionDeclaration)
        return_type = @type_codegen.c_type(fn.resolved_type.not_nil!)
        params = fn.params.map do |param|
          "#{@type_codegen.c_type(param.resolved_type.not_nil!)} #{param.name}"
        end.join(", ")

        @io.puts "#{return_type} #{fn.name}(#{params}) {"
        @io.puts "return #{@expression_codegen.emit(fn.body)};"
        @io.puts "}"
      end

      def emit_procedure(pc : ASTData::ProcedureDeclaration)
        return_type = @type_codegen.c_type(pc.resolved_type.not_nil!)
        params = pc.params.map do |param|
          "#{@type_codegen.c_type(param.resolved_type.not_nil!)} #{param.name}"
        end.join(", ")

        @io.puts "#{return_type} #{pc.name}(#{params}) {"
        emit_statements(pc.body.statements)
        @io.puts "}"
      end

      def emit_statements(stmts : Array(ASTData::Statement))

      end
    end
  end
end