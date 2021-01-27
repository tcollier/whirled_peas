require 'whirled_peas/utils/formatted_string'

require_relative 'container_coords'
require_relative 'painter'

module WhirledPeas
  module Graphics
    class ContainerPainter < Painter
      PADDING = ' '

      def initialize(name, settings)
        super
        @children = []
      end

      def paint(canvas, &block)
        return unless canvas.writable?
        return unless needs_printing?
        canvas_coords = coords(canvas)
        stroke_left = canvas_coords.border_left
        stroke_top = canvas_coords.border_top
        formatting = [*settings.border.color, *settings.bg_color]
        if settings.border.top?
          canvas.stroke(stroke_left, stroke_top, top_border_stroke(canvas_coords), formatting, &block)
          stroke_top += 1
        end
        middle_border = dimensions.num_rows > 1 ? middle_border_stroke(canvas_coords) : ''
        dimensions.num_rows.times do |row_num|
          if row_num > 0 && settings.border.inner_horiz?
            canvas.stroke(stroke_left, stroke_top, middle_border, formatting, &block)
            stroke_top += 1
          end
          canvas_coords.inner_grid_height.times do |row_within_cell|
            canvas.stroke(stroke_left, stroke_top, content_line_stroke(canvas_coords, row_within_cell), formatting, &block)
            stroke_top += 1
          end
          if settings.scrollbar.horiz?
            canvas.stroke(stroke_left, stroke_top, bottom_scroll_stroke(canvas_coords), formatting, &block)
            stroke_top += 1
          end
        end
        if settings.border.bottom?
          canvas.stroke(stroke_left, stroke_top, bottom_border_stroke(canvas_coords), formatting, &block)
          stroke_top += 1
        end
      end

      def add_child(child)
        children << child
      end

      def num_children
        children.length
      end

      def children?
        num_children > 0
      end

      def each_child(&block)
        children.each(&block)
      end

      private

      attr_reader :children

      def needs_printing?
        return true if settings.bg_color
        return true if settings.border.outer?
        return true if dimensions.num_cols > 1 && settings.border.inner_vert?
        return true if dimensions.num_rows > 1 && settings.border.inner_horiz?
        settings.scrollbar.horiz? || settings.scrollbar.vert?
      end

      def coords(canvas)
        ContainerCoords.new(canvas, dimensions, settings)
      end

      def horiz_justify_offset(containing_width)
        if settings.align_center?
          [(dimensions.content_width - containing_width) / 2, 0]
        elsif settings.align_right?
          [dimensions.content_width - containing_width, 0]
        elsif settings.align_between?
          return [0, 0] if num_children == 1
          [0, (dimensions.content_width - containing_width) / (num_children - 1)]
        elsif settings.align_around?
          full_spacing = (dimensions.content_width - containing_width) / num_children
          [full_spacing / 2, full_spacing]
        elsif settings.align_evenly?
          spacing = (dimensions.content_width - containing_width) / (num_children + 1)
          [spacing, spacing]
        else
          [0, 0]
        end
      end

      def vert_justify_offset(containing_height)
        if settings.valign_middle?
          [(dimensions.content_height - containing_height) / 2, 0]
        elsif settings.valign_bottom?
          [dimensions.content_height - containing_height, 0]
        elsif settings.valign_between?
          return [0, 0] if num_children == 1
          [0, (dimensions.content_height - containing_height) / (num_children - 1)]
        elsif settings.valign_around?
          full_spacing = (dimensions.content_height - containing_height) / num_children
          [full_spacing / 2, full_spacing]
        elsif settings.valign_evenly?
          spacing = (dimensions.content_height - containing_height) / (num_children + 1)
          [spacing, spacing]
        else
          [0, 0]
        end
      end

      def line_stroke(left_border, junc_border, right_border, &block)
        stroke = ''
        stroke += left_border if settings.border.left?
        dimensions.num_cols.times do |col_num|
          stroke += junc_border if col_num > 0 && settings.border.inner_vert?
          stroke += yield
        end
        stroke += right_border if settings.border.right?
        stroke
      end

      def top_border_stroke(canvas_coords)
        line_stroke(
          settings.border.style.top_left,
          settings.border.style.top_junc,
          settings.border.style.top_right
        ) do
          settings.border.style.top_horiz * (canvas_coords.inner_grid_width + (settings.scrollbar.vert? ? 1 : 0))
        end
      end

      def middle_border_stroke(canvas_coords)
        line_stroke(
          settings.border.style.left_junc,
          settings.border.style.cross_junc,
          settings.border.style.right_junc
        ) do
          settings.border.style.middle_horiz * (canvas_coords.inner_grid_width + (settings.scrollbar.vert? ? 1 : 0))
        end
      end

      def bottom_border_stroke(canvas_coords)
        line_stroke(
          settings.border.style.bottom_left,
          settings.border.style.bottom_junc,
          settings.border.style.bottom_right
        ) do
          settings.border.style.bottom_horiz * (canvas_coords.inner_grid_width + (settings.scrollbar.vert? ? 1 : 0))
        end
      end

      def content_line_stroke(canvas_coords, row_within_cell)
        line_stroke(
          settings.border.style.left_vert,
          settings.border.style.middle_vert,
          settings.border.style.right_vert,
        ) do
          if settings.scrollbar.vert?
            if dimensions.children_height <= canvas_coords.grid_height || children.first.settings.position.top > 0
              scrollbar_char = GUTTER
            else
              scrollbar_char = vert_scroll_char(
                dimensions.children_height + dimensions.padding_height,
                canvas_coords.inner_grid_height,
                -children.first.settings.position.top,
                row_within_cell
              )
            end
            PADDING * canvas_coords.inner_grid_width + scrollbar_char
          else
            PADDING * canvas_coords.inner_grid_width
          end
        end
      end

      def bottom_scroll_stroke(canvas_coords)
        line_stroke(
          settings.border.style.left_vert,
          settings.border.style.middle_vert,
          settings.border.style.right_vert,
        ) do
          canvas_coords.inner_grid_width.times.map do |col_within_cell|
            horiz_scroll_char(
              dimensions.children_width + dimensions.padding_width,
              canvas_coords.inner_grid_width,
              -children.first.settings.position.left,
              col_within_cell
            )
          end.join
        end
      end

      GUTTER = ' '
      HORIZONTAL = %w[▗ ▄ ▖]
      VERTICAL = %w[
        ▗
        ▐
        ▝
      ]

      def horiz_scroll_char(col_count, viewable_col_count, first_visible_col, curr_col)
        scroll_char(col_count, viewable_col_count, first_visible_col, curr_col, HORIZONTAL)
      end

      def vert_scroll_char(row_count, viewable_row_count, first_visible_row, curr_row)
        scroll_char(row_count, viewable_row_count, first_visible_row, curr_row, VERTICAL)
      end

      private

      def scroll_char(total_count, viewable_count, first_visible, curr, chars)
        return GUTTER unless total_count > 0 && viewable_count > 0
        # The scroll handle has the exact same relative size and position in the scroll gutter
        # that the viewable content has in the total content area. For example, a content area
        # that is 50 columns wide with a view port that is 20 columns wide might look like
        #
        #    +---------1-----****2*********3******---4---------+
        #    |               *                   *             |
        #    |   hidden      *     viewable      *   hidden    |
        #    |               *                   *             |
        #    +---------1-----****2*********3******---4---------+
        #
        # The scoll gutter, would look like
        #
        #                    |......********.....|
        #
        # Scrolling all the way to the right results in
        #
        #    +---------1---------2---------3*********4*********+
        #    |                             *                   *
        #    |            hidden           *     viewable      *
        #    |                             *                   *
        #    +---------1---------2---------3*********4*********+
        #                                  |...........********|

        # The first task of determining how much of the handle is visible in a row/column is to
        # calculate the range (as a precentage of the total) of viewable items
        viewable_start = first_visible.to_f / total_count
        viewable_end = (first_visible + viewable_count).to_f / total_count

        # Always use the same length for the scroll bar so it does not give an inchworm effect
        # as it scrolls along.
        #
        # Also, double the value now to get granularity for half width
        # scrollbar characters.
        scrollbar_length = ((2 * viewable_count ** 2).to_f / total_count).ceil
        scrollbar_start = ((2 * first_visible * viewable_count).to_f / total_count).floor

        first_half = (scrollbar_start...scrollbar_start + scrollbar_length).include?(2 * curr)
        second_half = (scrollbar_start...scrollbar_start + scrollbar_length).include?(2 * curr + 1)

        if first_half && second_half
          chars[1]
        elsif first_half
          chars[2]
        elsif second_half
          chars[0]
        else
          GUTTER
        end
      end
    end
    private_constant :ContainerPainter
  end
end
