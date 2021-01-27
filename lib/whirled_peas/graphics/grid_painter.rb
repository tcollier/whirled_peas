require_relative 'container_dimensions'
require_relative 'container_painter'

module WhirledPeas
  module Graphics
    class GridPainter < ContainerPainter
      def paint(canvas, left, top, &block)
        super
        return unless canvas.writable?
        each_child.with_index do |child, index|
          col_index, row_index = grid_cell(index)
          left_offset, _ = horiz_justify_offset(child.dimensions.outer_width)
          top_offset, _ = vert_justify_offset(child.dimensions.outer_height)
          child_canvas = canvas.child(
            coords(left, top).content_left(col_index) + left_offset,
            coords(left, top).content_top(row_index) + top_offset,
            [dimensions.content_width, child.dimensions.outer_width].min,
            [dimensions.content_height, child.dimensions.outer_height].min
          )
          child.paint(
            child_canvas,
            coords(left, top).content_left(col_index) + left_offset,
            coords(left, top).content_top(row_index) + top_offset,
            &block
          )
        end
      end

      def dimensions
        @dimensions ||= begin
          if settings.num_cols.nil? || settings.num_cols == 0
            raise SettingsError, "`num_cols` must be set for GridSettings(#{name})"
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

      private

      def grid_cell(index)
        if settings.horizontal_flow?
          col_index, row_index = [index % dimensions.num_cols, index / dimensions.num_cols]
          col_index = dimensions.num_cols - col_index - 1 if settings.reverse_flow?
        else
          col_index, row_index = [index / dimensions.num_rows, index % dimensions.num_rows]
          row_index = dimensions.num_rows - row_index - 1 if settings.reverse_flow?
        end
        [col_index, row_index]
      end
    end
    private_constant :BoxPainter
  end
end
