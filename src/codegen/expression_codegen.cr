

require "../ast_data/*"
require "../types/*"

module DoisC
  module Codegen
    class ExpressionCodegen < BaseCodegen

      def initialize(@emitter : Emitter)
      end

      def emit(expr : ASTData::Expression)
        case expr
        when ASTData::IntLiteral
          expr.value.to_s
        when ASTData::FloatLiteral
          expr.value.to_s
        when ASTData::BoolLiteral
          expr.value ? "true" : "false"
        when ASTData::StringLiteral
          emit_string_literal(expr)
        when ASTData::Identifier
          emitter << sanitize_name(expr.name)
        when ASTData::BinaryExpression
          emit_binary(expr)
        else
          raise "Unsupported expression codegen for #{expr.class}"
        end
      end

      private def emit_binary(expr : ASTData::BinaryExpression)
        left = emit(expr.left)
        right = emit(expr.right)
        emitter << "(#{left} #{expr.operator} #{right})"
      end

      private def emit_string_literal(expr : ASTData::StringLiteral)
        escaped = expr.value.gsub("\\", "\\\\").gsub("\"", "\\\"")
        emitter << "\"#{escaped}\""
      end

      private def sanitize_name(name : String) : String
        name.gsub(/[^a-zA-Z0-9_]/, "_")
      end
    end
  end
end