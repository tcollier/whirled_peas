require 'highline'

require 'whirled_peas/utils/ansi'

require_relative 'renderer'

module WhirledPeas
  module Graphics
    class Screen
      def self.current_dimensions
        width, height = HighLine.new.terminal.terminal_size
        [width || 0, height || 0]
      end

      def initialize(output=STDOUT)
        @output = output
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
        output.print Utils::Ansi.clear
        output.print Utils::Ansi.cursor_pos(top: height - 1)
        output.print Utils::Ansi.cursor_visible(true)
        output.flush
      end

      protected

      def refresh_size!
        @width, @height = self.class.current_dimensions
      end

      private

      attr_reader :output, :cursor, :terminal, :width, :height

      def draw
        strokes = [Utils::Ansi.cursor_visible(false), Utils::Ansi.cursor_pos, Utils::Ansi.clear_down]
        Renderer.new(@template, width, height).paint do |left, top, fstring|
          next unless fstring.length > 0
          strokes << Utils::Ansi.cursor_pos(left: left, top: top)
          strokes << fstring
        end
        strokes.each { |stroke| output.print(stroke) }
        output.flush
        @refreshed_width = width
        @refreshed_height = height
      end
    end
  end
end
