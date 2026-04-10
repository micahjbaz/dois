module DoisC
  module Codegen
    class Emitter
      def initialize(@io : IO::Memory)
        @indent_level = 0
      end

      def indent
        @indent_level += 1
      end

      def dedent
        @indent_level -= 1
      end

      def puts(input = "")
        @io << ("  " * @indent_level)
        @io << input
        @io << '\n'
      end

      def <<(input : String)
        @io << input
      end

      def with_indent
        indent
        yield
        dedent
      end

      def clear
        @io.clear
        @indent_level = 0
      end

      def to_s
        @io.to_s
      end
    end
  end
end