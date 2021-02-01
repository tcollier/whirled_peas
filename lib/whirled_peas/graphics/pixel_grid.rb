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
