require 'whirled_peas/utils/ansi'

require_relative 'content_painter'

module WhirledPeas
  module Graphics
    class GraphPainter < ContentPainter
      def paint(canvas, left, top, &block)
        axis_formatting = [*settings.axis_color, *settings.bg_color]
        plot_formatting = [*settings.color, *settings.bg_color]
        axes_lines.each.with_index do |axis_line, row_index|
          canvas.stroke(left, top + row_index, axis_line, axis_formatting, &block)
          next if row_index >= plot_lines.length
          canvas.stroke(left + 1, top + row_index, plot_lines[row_index], plot_formatting, &block)
        end
      end

      private

      def content_lines
        axes_lines
      end

      def plot_lines
        return @plot_lines if @plot_lines
        min_y = 1.0 / 0
        max_y = -1.0 / 0
        if settings.width
          interpolated = inner_width.times.map do |i|
            x = (i * (content.length - 1).to_f / inner_width).floor
            max_y = content[x] if content[x] > max_y
            min_y = content[x] if content[x] < min_y
            content[x]
          end
        else
          interpolated = content
          content.each do |y|
            max_y = y if y > max_y
            min_y = y if y < min_y
          end
        end
        scaled = interpolated.map do |y|
          (2 * inner_height * (y - min_y).to_f / (max_y - min_y)).floor
        end
        @plot_lines = Array.new(inner_height) { '' }
        scaled.each.with_index do |y, x_index|
          @plot_lines.each.with_index do |row, row_index|
            y_index = inner_height - row_index - 1
            asc, next_y = if scaled.length == 1
              [true, y]
            elsif x_index == scaled.length - 1
              y >= scaled[x_index - 1]
              [true, y]
            else
              scaled[x_index + 1] >= y
              [true, scaled[x_index + 1]]
            end
            if asc
              top_half = (y...next_y).include?(2 * y_index + 1)
              bottom_half = (y...next_y).include?(2 * y_index)
            else
              top_half = (next_y...y).include?(2 * y_index + 1)
              bottom_half = (next_y...y).include?(2 * y_index)
            end
            row << if top_half && bottom_half
              '█'
            elsif top_half
              '▀'
            elsif bottom_half
              '▄'
            else
              ' '
            end
          end
        end
        @plot_lines
      end

      def inner_height
        settings.height - 1
      end

      def inner_width
        settings.width.nil? ? content.length : settings.width - 1
      end

      def axes_lines
        return @axes_lines if @axes_lines
        @axes_lines = inner_height.times.map { '┃' }
        @axes_lines << '┗' + '━' * inner_width
        @axes_lines
      end
    end
  end
end
