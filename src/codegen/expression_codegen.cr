

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
          write expr.value.to_s
        when ASTData::FloatLiteral
          write expr.value.to_s
        when ASTData::BoolLiteral
          write expr.value ? "true" : "false"
        when ASTData::StringLiteral
          emit_string_literal(expr)
        when ASTData::BinaryExpression
          emit_binary(expr)
        when ASTData::IdentifierExpression
          emit_identifier_expression(expr)
        else
          raise "Unsupported expression codegen for #{expr.class}"
        end
      end

      private def emit_binary(expr : ASTData::BinaryExpression)
        write "("
        emit(expr.left)
        write " "
        write expr.operator.to_s
        write " "
        emit(expr.right)
        write ")"
        # write "(#{left} #{expr.operator.to_s} #{right})"
      end

      private def emit_string_literal(expr : ASTData::StringLiteral)
        escaped = expr.value.gsub("\\", "\\\\").gsub("\"", "\\\"")
        write "\"#{escaped}\""
      end

      private def emit_identifier_expression(expr : ASTData::IdentifierExpression)
        write sanitize_name(expr.identifier.to_s)
      end

      private def sanitize_name(name : String) : String
        name.gsub(/[^a-zA-Z0-9_]/, "_")
      end
    end
  end
end