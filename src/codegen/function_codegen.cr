

module DoisC
  module Codegen
    class FunctionCodegen < BaseCodegen
      def initialize(@type_codegen : TypeCodegen, @expression_codegen : ExpressionCodegen, @emitter : Emitter)
      end

      def emit_function(fn : ASTData::FunctionDeclaration)
        return_type = @type_codegen.c_type(fn.resolved_type.not_nil!)
        params = fn.params.map do |param|
          "#{@type_codegen.c_type(param.resolved_type.not_nil!)} #{param.name}"
        end.join(", ")

        writeln "#{return_type} #{fn.name}(#{params}) {"
        with_indent do
          write "return "
          @expression_codegen.emit(fn.body)
          writeln ";"
        end
        writeln "}"
      end

      def emit_procedure(pc : ASTData::ProcedureDeclaration)
        return_type = @type_codegen.c_type(pc.resolved_type.not_nil!)
        params = pc.params.map do |param|
          "#{@type_codegen.c_type(param.resolved_type.not_nil!)} #{param.name}"
        end.join(", ")

        writeln "#{return_type} #{pc.name}(#{params}) {"
        with_indent do
          emit_statements(pc.body.statements)
        end
        writeln "}"
      end

      def emit_statements(stmts : Array(ASTData::Statement))
        stmts.each do |stmt|
          emit_statement(stmt)
        end
      end

      def emit_statement(stmt : ASTData::Statement)
        case stmt
        when ASTData::Binding
          type = @type_codegen.c_type(stmt.resolved_type.not_nil!)
          write "#{type} #{stmt.name} = "
          @expression_codegen.emit(stmt.value)
        when ASTData::ExpressionStatement
          @expression_codegen.emit(stmt.expression)
        else
          writeln "/* unsupported statement: #{stmt.class} */"
        end
        writeln ";"
      end
    end
  end
end