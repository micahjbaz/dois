require "./global"
require "../types/type"

module DoisC
  module Environment

    # Holds context as verifier traverses AST's concrete types
    class VerificationContext

      # ===== Global =====
      getter globals : Global

      # ===== Variable Scopes =====
      @scopes : Array(Hash(String, Types::Type))

      # ===== Generic Scopes =====
      @generic_scopes : Array(Hash(String, Types::GenericTypeParameter))

      # ===== Function Context =====
      @current_return_type : Types::Type?

      # ===== Module Scope =====
      @module_scope : Array(String)

      # ===== Loop Depth (for break checking) =====
      @loop_depth : Int32

      def initialize(@globals : Global)
        @scopes = [{} of String => Types::Type]
        @generic_scopes = [{} of String => Types::GenericTypeParameter]
        @current_return_type = nil
        @module_scope = [] of String
        @loop_depth = 0
      end

      # ============================
      # Variable Scope
      # ============================

      def enter_scope
        @scopes.push({} of String => Types::Type)
      end

      def exit_scope
        @scopes.pop
      end

      def declare(name : String, type : Types::Type)
        @scopes.last[name] = type
      end

      def lookup(name : String) : Types::Type?
        @scopes.reverse_each do |scope|
          return scope[name]? if scope.has_key?(name)
        end
        nil
      end

      # ============================
      # Generic Scope
      # ============================

      def enter_generic_scope
        @generic_scopes.push({} of String => Types::GenericTypeParameter)
      end

      def exit_generic_scope
        @generic_scopes.pop
      end

      def bind_generic(name : String, param : Types::GenericTypeParameter)
        @generic_scopes.last[name] = param
      end

      def lookup_generic(name : String) : Types::GenericTypeParameter?
        @generic_scopes.reverse_each do |scope|
          return scope[name]? if scope.has_key?(name)
        end
        nil
      end

      def current_generic_scope : Hash(String, Types::GenericTypeParameter)
        @generic_scopes.last || {} of String => Types::GenericTypeParameter
      end

      # ============================
      # Module Scope
      # ============================

      def push_module(name : String)
        @module_scope << name
      end

      def pop_module
        @module_scope.pop
      end

      def current_module_scope : Array(String)
        @module_scope.dup
      end

      # ============================
      # Loop Tracking
      # ============================

      def enter_loop
        @loop_depth += 1
      end

      def exit_loop
        @loop_depth -= 1
      end

      def inside_loop? : Bool
        @loop_depth > 0
      end

      # ============================
      # Function Return Context
      # ============================

      def with_return_type(type : Types::Type)
        old = @current_return_type
        @current_return_type = type
        yield
        @current_return_type = old
      end

      def current_return_type : Types::Type?
        @current_return_type
      end
    end
    
  end
end