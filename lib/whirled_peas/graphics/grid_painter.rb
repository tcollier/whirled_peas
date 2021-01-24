require_relative 'container_dimensions'
require_relative 'container_painter'

module WhirledPeas
  module Graphics
    class GridPainter < ContainerPainter
      def paint(canvas, &block)
        super
        return unless canvas.writable?
        each_child.with_index do |child, index|
          col_index = index % dimensions.num_cols
          row_index = index / dimensions.num_cols
          child_canvas = Canvas.new(
            coords(canvas).content_left(col_index),
            coords(canvas).content_top(row_index),
            dimensions.outer_width,
            dimensions.outer_height
          )
          child.paint(child_canvas, &block)
        end
      end

      def dimensions
        @dimensions ||= begin
          if settings.num_cols.nil? || settings.num_cols == 0
            raise SettingsError, "`num_cols` must be set for GridSettings<#{name}>"
          end
          num_cols = settings.num_cols
          num_rows = (num_children.to_f / num_cols).ceil
          content_width = 0
          each_child do |child|
            if child.dimensions.outer_width > content_width
              content_width = child.dimensions.outer_width
            end
          end
          content_height = 0
          each_child do |child|
            if child.dimensions.outer_height > content_height
              content_height = child.dimensions.outer_height
            end
          end
          ContainerDimensions.new(
            settings, content_width, content_height, num_cols, num_rows
          )
        end
      end
    end
    private_constant :BoxPainter
  end
end