require 'whirled_peas/utils/formatted_string'
require 'whirled_peas/utils/title_font'

require_relative 'content_dimensions'
require_relative 'content_painter'

module WhirledPeas
  module Graphics
    class TextPainter < ContentPainter
      def paint(canvas, left, top, &block)
        return unless canvas.writable?
        formatting = [*settings.color, *settings.bg_color]
        formatting << Utils::Ansi::BOLD if settings.bold?
        if settings.underline? && settings.title_font.nil?
          formatting << Utils::Ansi::UNDERLINE
        end
        content_lines.each.with_index do |line, index|
          canvas.stroke(left, top + index, line, formatting, &block)
        end
      end

      private

      def content_lines
        @content_lines = if settings.title_font
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
