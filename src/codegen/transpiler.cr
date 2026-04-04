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
        emit_c_declarations(ast)
        emit_c_dois_main(ast)
        emit_c_main
        @io.to_s
      end


      private def emit_c_declarations(ast : ASTData::AST)
        ast.module_decl.body.each do |stmt|
          # Special case: skip 'proc main', will be emitted in dois_main
          if stmt.is_a?(ASTData::ProcedureDeclaration) && stmt.name == "main"
            next
          end

          next unless stmt.is_a?(ASTData::Declaration)
          @declaration_codegen.emit(stmt)
          @io.puts
        end
      end

      private def emit_c_dois_main(ast : ASTData::AST)
        @io.puts "void dois_main(void) {"

        main_proc = ast.module_decl.body.find do |stmt|
          stmt.is_a?(ASTData::ProcedureDeclaration) && stmt.name == "main"
        end

        unless main_proc.is_a?(ASTData::ProcedureDeclaration)
          raise "Error: module '#{ast.module_decl.name}' does not define a 'proc main'"
        end

        main_proc.body.statements.each do |main_stmt|
          @function_codegen.emit_statement(main_stmt)
        end

        # Optionally, emit other top-level executable statements
        ast.module_decl.body.each do |stmt|
          next if stmt.is_a?(ASTData::Declaration) || (stmt.is_a?(ASTData::ProcedureDeclaration) && stmt.name == "main")

          # executable top-level statement lowering goes here
        end

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