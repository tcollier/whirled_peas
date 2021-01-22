module WhirledPeas
  module Utils
    # Helper module for working with ANSI escape codes. The most useful ANSI escape codes
    # relate to text formatting.
    #
    # @see https://en.wikipedia.org/wiki/ANSI_escape_code
    module Ansi
      ESC = "\033"

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

      END_FORMATTING = 0
      private_constant :END_FORMATTING

      class << self
        def cursor_pos(top: 0, left: 0)
          "#{ESC}[#{top + 1};#{left + 1}H"
        end

        def cursor_visible(visible)
          visible ? "#{ESC}[?25h" : "#{ESC}[?25l"
        end

        def clear_down
          "#{ESC}[J"
        end

        # Format the string with the ANSI escapes codes for the given integer codes
        #
        # @param str [String] the string to format
        # @param codes [Array<Integer>] the integer part of the ANSI escape code (see
        #   constants in this module for codes and meanings)
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

        # If the string has unclosed formatting, add the end formatting characters to
        # the end of the string
        def close_formatting(str)
          codes = str.scan(/#{ESC}\[(\d+)m/)
          if codes.length > 0 && codes.last[0] != END_FORMATTING.to_s
            "#{str}#{esc_seq(END_FORMATTING)}"
          else
            str
          end
        end

        # Return a substring of the input string that preservse the formatting
        #
        # @param str [String] the (possibly formatted) string
        # @param first_visible_character [Integer] the index of the first character to
        #   include in the substring (ignoring all hidden formatting characters)
        # @param num_visible_chars [Integer] the maximum number of visible characters to
        #   include in the substring (ignoring all hidden formatting characters)
        def substring(str, first_visible_character, num_visible_chars)
          substr = ''
          is_visible = true
          visible_index = 0
          substr_visible_len = 0
          str.chars.each do |char|
            in_substring = (visible_index >= first_visible_character)
            is_visible = false if is_visible && char == ESC
            visible_index += 1 if is_visible
            if !is_visible || in_substring
              substr += char
              substr_visible_len += 1 if is_visible
            end
            is_visible = true if !is_visible && char == 'm'
            break if substr_visible_len == num_visible_chars
          end
          close_formatting(substr)
        end

        private

        def esc_seq(code)
          "#{ESC}[#{code}m"
        end
      end
    end
  end
end
