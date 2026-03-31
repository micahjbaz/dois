require "./*"

module DoisC
  module Codegen
    # Transpiles the typed Dois AST into final C source text.
    #
    # This layer should NOT walk expressions itself anymore.
    # It should only orchestrate the specialized emitters.
    class Transpiler

      def initialize
        @io = IO::Memory.new
        @type_codegen = TypeCodegen.new(@io)
        @expression_codegen = ExpressionCodegen.new(@io)
        @function_codegen = FunctionCodegen.new(@type_codegen, @expression_codegen, @io)
        @declaration_codegen = DeclarationCodegen.new(
          @type_codegen,
          @function_codegen,
          @io
        )
      end

      # Main compiler entry point.
      # main.cr currently calls `generate`, so keep that stable.
      def generate(ast : ASTData::AST) : String
        transpile(ast)
      end

      def transpile(ast : ASTData::AST) : String
        @io.clear
        emit_c_include_runtime
        emit_c_dois_main(ast)
        emit_c_main
        @io.to_s
      end

      private def emit_c_dois_main(ast : ASTData::AST)
        @io.puts "void dois_main(void) {"
        @declaration_codegen.emit_all(ast)
        @io.puts "}"
        @io.puts
      end

      private def emit_c_main
        @io.puts "int main(void) {"
        @io.puts "  dois_runtime_init();"
        @io.puts "  dois_main();"
        @io.puts "  dois_runtime_shutdown();"
        @io.puts "  return 0;"
        @io.puts "}"
      end

      private def emit_c_include_runtime
        @io.puts "#include \"runtime/runtime.h\""
        @io.puts
      end
    end
  end
end