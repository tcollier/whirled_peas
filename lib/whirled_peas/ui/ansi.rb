module WhirledPeas
  module UI
    DEBUG_COLOR = ARGV.include?('--debug-color')

    module Ansi
      BOLD = 1
      UNDERLINE = 4

      BLACK = 30
      RED = 31
      GREEN = 32
      YELLOW = 33
      BLUE = 34
      MAGENTA = 35
      CYAN = 36
      WHITE = 37

      END_FORMATTING = 0

      class << self
        def format(str, codes)
          if str.empty? || codes.length == 0
            str
          else
            start_formatting = codes.map(&method(:esc_seq)).join
            "#{start_formatting}#{str}#{esc_seq(END_FORMATTING)}"
          end
        end

        def clear
          esc_seq(END_FORMATTING)
        end

        def hidden_width(line)
          return 0 if DEBUG_COLOR
          width = 0
          line.scan(/\033\[\d+m/).each { |f| width += f.length }
          width
        end

        def close_formatting(line)
          codes = line.scan(DEBUG_COLOR ? /<(\d+)>/ : /\033\[(\d+)m/)
          if codes.length > 0 && codes.last[0] != END_FORMATTING.to_s
            "#{line}#{esc_seq(END_FORMATTING)}"
          else
            line
          end
        end

        private

        def esc_seq(code)
          DEBUG_COLOR ? "<#{code}>" : "\033[#{code}m"
        end
      end
    end

    class Color
      BRIGHT_OFFSET = 60
      private_constant :BRIGHT_OFFSET

      def self.validate!(color)
        return unless color
        if color.is_a?(Symbol)
          error_message = "Unsupported #{self.name.split('::').last}: #{color}"
          match = color.to_s.match(/^(bright_)?(\w+)$/)
          begin
            color = self.const_get(match[2].upcase)
            raise ArgumentError, error_message unless color.is_a?(Color)
            if match[1]
              raise ArgumentError, error_message if color.bright?
              color.bright
            else
              color
            end
          rescue NameError
            raise ArgumentError, error_message
          end
        else
          color
        end
      end

      def initialize(code, bright=false)
        @code = code
        @bright = bright
      end

      def bright?
        @bright
      end

      def bright
        bright? ? self : self.class.new(@code + BRIGHT_OFFSET, true)
      end

      def to_s
        @code.to_s
      end

      def inspect
        "#{self.class.name.split('::').last}<code=#{@code}, bright=#{@bright}>"
      end
    end
    private_constant :Color

    class BgColor < Color
      BG_OFFSET = 10
      private_constant :BG_OFFSET

      BLACK = new(Ansi::BLACK + BG_OFFSET)
      RED = new(Ansi::RED + BG_OFFSET)
      GREEN = new(Ansi::GREEN + BG_OFFSET)
      YELLOW = new(Ansi::YELLOW + BG_OFFSET)
      BLUE = new(Ansi::BLUE + BG_OFFSET)
      MAGENTA = new(Ansi::MAGENTA + BG_OFFSET)
      CYAN = new(Ansi::CYAN + BG_OFFSET)
      WHITE = new(Ansi::WHITE + BG_OFFSET)
      GRAY = BLACK.bright
    end

    class TextColor < Color
      BLACK = new(Ansi::BLACK)
      RED = new(Ansi::RED)
      GREEN = new(Ansi::GREEN)
      YELLOW = new(Ansi::YELLOW)
      BLUE = new(Ansi::BLUE)
      MAGENTA = new(Ansi::MAGENTA)
      CYAN = new(Ansi::CYAN)
      WHITE = new(Ansi::WHITE)
      GRAY = BLACK.bright

      SHORTCUTS = {
        black: BLACK,
        red: RED,
        bright_red: RED.bright,
        green: GREEN,
        bright_green: GREEN.bright,
        yellow: YELLOW,
        bright_yellow: YELLOW.bright,
        blue: BLUE,
        bright_blue: BLUE.bright,
        magenta: MAGENTA,
        bright_magenta: MAGENTA.bright,
        cyan: CYAN,
        bright_cyan: CYAN.bright,
        white: WHITE,
        bright_white: WHITE.bright,
        gray: GRAY
      }
    end

    module TextFormat
      BOLD = Ansi::BOLD
      UNDERLINE = Ansi::UNDERLINE
    end
  end
end
