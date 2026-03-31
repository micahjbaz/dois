

module DoisC
  module Codegen
    class TypeCodegen

      def initialize(@io : IO::Memory)
      end

      # Maps a resolved Dois type into a concrete C type spelling.
      # This will be used later by expression/function codegen.
      def c_type(type : Types::Type) : String
        case type
        when Types::NominalType
          case type.name
          when "Int"
            "int64_t"
          when "Float"
            "double"
          when "Bool"
            "bool"
          when "String"
            "const char*"
          else
            "void*"
          end
        else
          "void*"
        end
      end

      def emit_product(decl : ASTData::ProductTypeDeclaration)
        name = sanitize_name(decl.name)

        @io.puts "struct #{name} {"
        decl.fields.each do |field|
          field_type = field.resolved_type.nil? ? c_type(field.resolved_type.not_nil!) : "void*"
          @io.puts "  #{field_type} #{field.name};"
        end
        @io.puts "};"
        @io.puts
      end

      def emit_union(decl : ASTData::UnionTypeDeclaration)
        name = sanitize_name(decl.name)

        @io.puts "struct #{name} {"
        @io.puts "  int tag;"
        @io.puts "  union {"
        decl.variants.each_with_index do |variant, index|
          variant_name = sanitize_name(variant.name)
          payload_type = "int"
          @io.puts "    #{payload_type} #{variant_name}; // tag #{index}"
        end
        @io.puts "  } as;"
        @io.puts "};"
        @io.puts
      end

      private def sanitize_name(name : String) : String
        name.gsub(/[^A-Za-z0-9_]/, "_")
      end
    end
  end
end