require 'highline'

require_relative 'ansi'
require_relative 'painter'

module WhirledPeas
  module UI
    class Screen
      def initialize(print_output=true)
        @print_output = print_output
        @terminal = HighLine.new.terminal
        @strokes = []
        refresh_size!
        Signal.trap('SIGWINCH', proc { self.refresh_size! })
      end

      def paint(template)
        @template = template
        refresh
      end

      def needs_refresh?
        @refreshed_width != width || @refreshed_height != height
      end

      def refresh
        strokes = [Ansi.cursor_visible(false), Ansi.cursor_pos, Ansi.clear_down]
        Painter.paint(@template, Canvas.new(0, 0, width, height)) do |stroke|
          unless stroke.chars.nil?
            strokes << Ansi.cursor_pos(left: stroke.left, top: stroke.top)
            strokes << stroke.chars
          end
        end
        return unless @print_output
        strokes.each(&method(:print))
        STDOUT.flush
        @refreshed_width = width
        @refreshed_height = height
      end

      def finalize
        return unless @print_output
        print Ansi.clear
        print Ansi.cursor_pos(top: height - 1)
        print Ansi.cursor_visible(true)
        STDOUT.flush
      end

      protected

      def refresh_size!
        @width, @height = terminal.terminal_size
      end

      private

      attr_reader :cursor, :terminal, :width, :height
    end
  end
end
