module WhirledPeas
  module Utils
    # Helper module for working with ANSI escape codes. The most useful ANSI escape codes
    # relate to text formatting.
    #
    # @see https://en.wikipedia.org/wiki/ANSI_escape_code
    module Ansi
      ESC = "\033"

      END_FORMATTING = 0
      private_constant :END_FORMATTING

      # Text formatting constants
      BOLD = 1
      UNDERLINE = 4

      # Text and background color constants
      BLACK = 30
      RED = 31
      GREEN = 32
      YELLOW = 33
      BLUE = 34
      MAGENTA = 35
      CYAN = 36
      WHITE = 37

      # Bright colors are offset by this much from their standard versions
      BRIGHT_OFFSET = 60

      class << self
        def with_screen(output=STDOUT, width: nil, height: nil, &block)
          require 'highline'
          unless width && height
            width, height = HighLine.new.terminal.terminal_size
          end
          yield width, height
        ensure
          output.print clear
          output.print cursor_pos(top: height - 1)
          output.print cursor_visible(true)
          output.flush
        end

        def cursor_pos(top: 0, left: 0)
          "#{ESC}[#{top + 1};#{left + 1}H"
        end

        def cursor_visible(visible)
          visible ? "#{ESC}[?25h" : "#{ESC}[?25l"
        end

        def clear_down
          "#{ESC}[J"
        end

        def clear
          esc_seq(END_FORMATTING)
        end

        def esc_seq(code)
          "#{ESC}[#{code}m"
        end
      end
    end
  end
end
