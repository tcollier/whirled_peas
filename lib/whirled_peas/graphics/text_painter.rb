require 'whirled_peas/utils/formatted_string'
require 'whirled_peas/utils/title_font'

require_relative 'painter'
require_relative 'text_dimensions'

module WhirledPeas
  module Graphics
    class TextPainter < Painter
      attr_reader :content

      def paint(canvas, &block)
        return unless canvas.writable?
        formatting = [*settings.color, *settings.bg_color]
        formatting << Utils::Ansi::BOLD if settings.bold?
        if settings.underline? && settings.title_font.nil?
          formatting << Utils::Ansi::UNDERLINE
        end
        content.each.with_index do |line, index|
          canvas.stroke(canvas.start_left, canvas.start_top + index, line, formatting, &block)
        end
      end

      def dimensions
        TextDimensions.new(content)
      end

      def content=(content)
        @content = if settings.title_font
          Utils::TitleFont.to_s(
            content, settings.title_font
          ).split("\n")
        else
          content.split("\n")
        end
      end
    end
    private_constant :TextPainter
  end
end
