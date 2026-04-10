

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

        emitter.puts "#{return_type} #{fn.name}(#{params}) {"
        emitter.puts "return #{@expression_codegen.emit(fn.body)};"
        emitter.puts "}"
      end

      def emit_procedure(pc : ASTData::ProcedureDeclaration)
        return_type = @type_codegen.c_type(pc.resolved_type.not_nil!)
        params = pc.params.map do |param|
          "#{@type_codegen.c_type(param.resolved_type.not_nil!)} #{param.name}"
        end.join(", ")

        emitter.puts "#{return_type} #{pc.name}(#{params}) {"
        emit_statements(pc.body.statements)
        emitter.puts "}"
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
          expr = @expression_codegen.emit(stmt.value)
          emitter.puts "#{type} #{stmt.name} = #{expr};"
        when ASTData::ExpressionStatement
          expr = @expression_codegen.emit(stmt.expression)
          emitter.puts "#{expr};"
        else
          emitter.puts "/* unsupported statement: #{stmt.class} */"
        end
      end
    end
  end
end