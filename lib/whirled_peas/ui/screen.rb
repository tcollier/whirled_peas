require 'highline'

require 'whirled_peas/utils/ansi'

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
        draw
      end

      def refresh
        # No need to refresh if the screen dimensions have not changed
        return if @refreshed_width == width || @refreshed_height == height
        draw
      end

      def finalize
        return unless @print_output
        print Utils::Ansi.clear
        print Utils::Ansi.cursor_pos(top: height - 1)
        print Utils::Ansi.cursor_visible(true)
        STDOUT.flush
      end

      protected

      def refresh_size!
        @width, @height = terminal.terminal_size
      end

      private

      attr_reader :cursor, :terminal, :width, :height

      def draw
        strokes = [Utils::Ansi.cursor_visible(false), Utils::Ansi.cursor_pos, Utils::Ansi.clear_down]
        Painter.paint(@template, Canvas.new(0, 0, width, height)) do |stroke|
          unless stroke.chars.nil?
            strokes << Utils::Ansi.cursor_pos(left: stroke.left, top: stroke.top)
            strokes << stroke.chars
          end
        end
        return unless @print_output
        strokes.each(&method(:print))
        STDOUT.flush
        @refreshed_width = width
        @refreshed_height = height
      end
    end
  end
end
