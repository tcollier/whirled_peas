require 'highline'
require 'tty-cursor'

require_relative 'ansi'
require_relative 'painter'

module WhirledPeas
  module UI
    class Screen
      def initialize(print_output=true)
        @print_output = print_output
        @terminal = HighLine.new.terminal
        @cursor = TTY::Cursor
        @strokes = []
        refresh_size!
        Signal.trap('SIGWINCH', proc { self.refresh_size! })
      end

      def paint(template)
        strokes = [cursor.hide, cursor.move_to(0, 0), cursor.clear_screen_down]
        Painter.paint(template, Canvas.new(0, 0, width, height)) do |stroke|
          unless stroke.chars.nil?
            strokes << cursor.move_to(stroke.left, stroke.top)
            strokes << stroke.chars
          end
        end
        return unless @print_output
        strokes.each(&method(:print))
        STDOUT.flush
      end

      def finalize
        return unless @print_output
        print UI::Ansi.clear
        print cursor.move_to(0, height - 1)
        print cursor.show
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
