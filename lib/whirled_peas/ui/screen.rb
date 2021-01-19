require 'highline'
require 'tty-cursor'

require_relative 'ansi'
require_relative 'painter'

module WhirledPeas
  module UI
    class Screen
      def initialize
        Signal.trap('SIGWINCH', proc { self.refresh_size! })
        @terminal = HighLine.new.terminal
        @cursor = TTY::Cursor
        refresh_size!
      end

      def paint(template)
        buffered(template).each(&method(:print))
        STDOUT.flush
      end

      def finalize
        print UI::Ansi.clear
        print cursor.show
        STDOUT.flush
      end

      protected

      def buffered(template, &block)
        buffer = [cursor.hide, cursor.move_to(0, 0), cursor.clear_screen_down]
        Painter.paint(template, Canvas.new(0, 0, width, height)) do |stroke|
          buffer << cursor.move_to(stroke.top, stroke.left)
          buffer << stroke.chars
        end
        buffer
      end

      def refresh_size!
        @width, @height = terminal.terminal_size
      end

      private

      attr_reader :cursor, :terminal, :width, :height
    end
  end
end
