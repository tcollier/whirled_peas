require 'whirled_peas/settings/debugger'

require_relative 'container_painter'
require_relative 'text_painter'

module WhirledPeas
  module Graphics
    class Debugger
      def initialize(painter)
        @painter = painter
      end

      def debug(indent='')
        info = [
          "#{indent}* #{painter.class}(#{painter.name})",
        ]
        info << "#{indent + '  '}- Dimensions(#{dimensions})"
        info << "#{indent + '  '}- Settings"
        info << Settings::Debugger.new(painter.settings).debug(indent + '    ')
        if painter.is_a?(ContainerPainter)
          info << "#{indent + '  '}- Children"
          info += painter.each_child.map { |c| Debugger.new(c).debug(indent + '    ') }
        end
        info.join("\n")
      end

      private

      attr_reader :painter

      def dimensions
        outer = "#{painter.dimensions.outer_width}x#{painter.dimensions.outer_height}"
        if painter.is_a?(ContainerPainter)
          content = "#{painter.dimensions.content_width}x#{painter.dimensions.content_height}"
          grid = "#{painter.dimensions.num_cols}x#{painter.dimensions.num_rows}"
          "outer=#{outer}, content=#{content}, grid=#{grid}"
        else
          "outer=#{outer}"
        end
      end
    end
  end
end
