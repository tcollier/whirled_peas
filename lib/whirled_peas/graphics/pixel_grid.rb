module WhirledPeas
  module Graphics
    class PixelGrid
      Pixel = Struct.new(:char, :formatting)

      def initialize(width, height)
        @pixels = Array.new(height) { Array.new(width) { Pixel.new } }
      end

      def add_stroke(left, top, fstring)
        fstring.each_char.with_index do |char, offset|
          pixels[top][left + offset].char = char
          pixels[top][left + offset].formatting = fstring.formatting
        end
      end

      def pixel_at(col, row)
        pixels[row][col]
      end

      def diff(other)
        str = ''
        formatting = nil
        chars = ''
        pixels.each.with_index do |row, row_index|
          row.each.with_index do |pixel, col_index|
            if pixel == other.pixel_at(col_index, row_index)
              if chars != ''
                str += Utils::FormattedString.new(chars, formatting).to_s
                chars = ''
                formatting = nil
              end
            elsif chars == ''
              str += Utils::Ansi.cursor_pos(left: col_index, top: row_index)
              chars = pixel.char
              formatting = pixel.formatting
            elsif formatting != pixel.formatting
              str += Utils::FormattedString.new(chars, formatting).to_s
              chars = pixel.char
              formatting = pixel.formatting
            else
              chars += pixel.char
            end
          end
        end
        if chars != ''
          str += chars
          chars = ''
          formatting = nil
        end
        str
      end

      def to_s
        str = Utils::Ansi.cursor_pos(left: 0, top: 0) + Utils::Ansi.clear_down
        formatting = nil
        chars = ''
        pixels.each.with_index do |row, row_offset|
          str += Utils::Ansi.cursor_pos(left: 0, top: row_offset) if row_offset > 0
          row.each do |pixel|
            if pixel.formatting != formatting
              str += Utils::FormattedString.new(chars, formatting).to_s if chars != ''
              chars = ''
              formatting = pixel.formatting
            end
            chars << pixel.char
          end
          if chars != ''
            str += Utils::FormattedString.new(chars, formatting).to_s
            chars = ''
          end
        end
        str
      end

      private

      attr_reader :pixels
    end
  end
end
