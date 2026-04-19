require "../types/reference"
require "../types/definition"

module DoisC
  module Environment

    # Environment for type, function, and procedure definitions
    class Global

      # Canonical references
      @type_refs : Hash(String, Types::NominalTypeReference)

      # Resolved definitions
      @type_defs : Hash(Types::NominalTypeReference, Types::TypeDefinition)

      # Functions and procedures unified
      @func_defs : Hash(String, Types::FunctionDefinition)

      # Builtin procedures/functions provided by the compiler prelude.
      # These may still need special verifier/codegen handling, but they
      # should be registered here as part of the global semantic environment.
      @builtins : Set(String)

      getter func_defs : Hash(String, Types::FunctionDefinition)
      getter builtins : Set(String)

      def initialize
        @type_refs = {} of String => Types::NominalTypeReference
        @type_defs = {} of Types::NominalTypeReference => Types::TypeDefinition
        @func_defs = {} of String => Types::FunctionDefinition
        @builtins = Set(String).new

        # TODO need a cleaner way of starting prelude for atomic types etc
        # Pre-register atomic types
        Types::Atomic.each do |atomic|
          register_atomic_type(atomic)
        end

        register_builtin_prelude
      end

      private def register_atomic_type(atomic)
        defn = Types::AtomicTypeDefinition.new(atomic)
        ref = Types::NominalTypeReference.new(defn.name)
        @type_refs[defn.name] = ref
        @type_defs[ref] = defn
      end

      private def register_builtin_prelude
        register_builtin("print")
      end

      private def register_builtin(name : String)
        @builtins << name
      end

      def builtin?(name : String) : Bool
        @builtins.includes?(name)
      end

      def register_type(name : String)
        raise "Type #{name} already defined" if @type_refs.has_key?(name)
        @type_refs[name] = Types::NominalTypeReference.new(name)
      end

      def define_type(ref : Types::NominalTypeReference, defn : Types::TypeDefinition)
        @type_defs[ref] = defn
      end

      def get_or_create_type_ref(name : String)
        @type_refs[name] ||= Types::NamedTypeReference.new(name)
      end

      def type_reference(name : String) : Types::TypeReference?
        @type_refs[name]?
      end

      def type_definition(ref : Types::NominalTypeReference)
        @type_defs[ref]?
      end

      def define_function(name : String, defn : Types::FunctionDefinition)
        @func_defs[name] = defn
      end

      # Treat procedures as functions returning Result
      def define_procedure(name : String, defn : Types::FunctionDefinition)
        define_function(name, defn)
      end

      def function_definition(name : String)
        @func_defs[name]?
      end
    end
    
  end
end