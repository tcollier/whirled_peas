require 'whirled_peas/utils/formatted_string'

require_relative 'container_coords'
require_relative 'painter'
require_relative 'scrollbar_helper'

module WhirledPeas
  module Graphics
    # Abstract Painter for containers. Containers (as the name implies) contain other child
    # elements and must delegate painting of the children to the children themselves.
    class ContainerPainter < Painter
      PADDING = ' '

      def initialize(name, settings)
        super
        @children = []
      end

      # Paint the common attributes of containers (e.g. border and background color). Any
      # class that inherits from this one should call `super` at the start of its #paint
      # method, before painting its children.
      def paint(canvas, left, top, &block)
        return unless canvas.writable?
        return unless needs_printing?
        canvas_coords = coords(left, top)

        # Paint the border, background color, and scrollbar starting from the top left
        # border position, moving down row by row until we reach the bottom border
        # position
        stroke_left = canvas_coords.border_left
        stroke_top = canvas_coords.border_top

        # All strokes will have the same formatting options
        formatting = [*settings.border.color, *settings.bg_color]

        # Paint the top border if the settings call for it
        if settings.border.top?
          canvas.stroke(stroke_left, stroke_top, top_border_stroke(canvas_coords), formatting, &block)
          stroke_top += 1
        end
        # Precalculate the middle border container grids with more than 1 row
        middle_border = dimensions.num_rows > 1 ? middle_border_stroke(canvas_coords) : ''

        # Paint each grid row by row
        dimensions.num_rows.times do |row_num|
          # In a grid with N rows, we will need to paint N - 1 inner horizontal borders.
          # This code treats the inner horizontal border as the top of each row except for
          # the first one.
          if row_num > 0 && settings.border.inner_horiz?
            canvas.stroke(stroke_left, stroke_top, middle_border, formatting, &block)
            stroke_top += 1
          end

          # Paint the interior of each row (horizontal borders, veritical scroll bar and
          # background color for the padding and content area)
          canvas_coords.inner_grid_height.times do |row_within_cell|
            canvas.stroke(stroke_left, stroke_top, content_line_stroke(canvas_coords, row_within_cell), formatting, &block)
            stroke_top += 1
          end

          # Paint the horizontal scroll bar is the settings call for it
          if settings.scrollbar.horiz?
            canvas.stroke(stroke_left, stroke_top, bottom_scroll_stroke(canvas_coords), formatting, &block)
            stroke_top += 1
          end
        end

        # Paint the bottom border if the settings call for it
        if settings.border.bottom?
          canvas.stroke(stroke_left, stroke_top, bottom_border_stroke(canvas_coords), formatting, &block)
          stroke_top += 1
        end
      end

      # Tightly manage access to the children (rather than simply exposing the underlying
      # array). This allows subclasses to easily modify behavior based on that element's
      # specific settings.
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

      # Determine if there is anything to print for the container (this does not accont for
      # children, just the border, scrollbar, and background color)
      def needs_printing?
        return true if settings.bg_color
        return true if settings.border.outer?
        return true if dimensions.num_cols > 1 && settings.border.inner_vert?
        return true if dimensions.num_rows > 1 && settings.border.inner_horiz?
        settings.scrollbar.horiz? || settings.scrollbar.vert?
      end

      # Return an object that allows easy access to important coordinates within the container,
      # e.g. the left position where the left border is printed
      def coords(left, top)
        ContainerCoords.new(dimensions, settings, left, top)
      end

      # @return [Array<Integer>] a two-item array, the first being the amount of horizontal
      #   spacing to paint *before the first* child and the second being the amount of spacing
      #   to paint *between each* child
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

      # @return [Array<Integer>] a two-item array, the first being the amount of vertical
      #   spacing to paint *above the first* child and the second being the amount of spacing
      #   to paint *between each* child
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

      # Return a stroke for one line of the container
      #
      # @param left_border [String] the character to print as the first character if there
      #   is a left border
      # @param junc_border [String] the character to print as the junction between two grid
      #   columns if there is an inner vertical border
      # @param right_border [String] the character to print as the last character if there
      #   is a right border
      # @block [String] the block should yield a string that represents the interior
      #   (including padding) of a grid cell
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

      # Return the stroke for the top border
      def top_border_stroke(canvas_coords)
        line_stroke(
          settings.border.style.top_left,
          settings.border.style.top_junc,
          settings.border.style.top_right
        ) do
          settings.border.style.top_horiz * (canvas_coords.inner_grid_width + (settings.scrollbar.vert? ? 1 : 0))
        end
      end

      # Return the stroke for an inner horizontal border
      def middle_border_stroke(canvas_coords)
        line_stroke(
          settings.border.style.left_junc,
          settings.border.style.cross_junc,
          settings.border.style.right_junc
        ) do
          settings.border.style.middle_horiz * (canvas_coords.inner_grid_width + (settings.scrollbar.vert? ? 1 : 0))
        end
      end

      # Return the stroke for the bottom border
      def bottom_border_stroke(canvas_coords)
        line_stroke(
          settings.border.style.bottom_left,
          settings.border.style.bottom_junc,
          settings.border.style.bottom_right
        ) do
          settings.border.style.bottom_horiz * (canvas_coords.inner_grid_width + (settings.scrollbar.vert? ? 1 : 0))
        end
      end

      # Return the stroke for a grid row between any borders
      def content_line_stroke(canvas_coords, row_within_cell)
        line_stroke(
          settings.border.style.left_vert,
          settings.border.style.middle_vert,
          settings.border.style.right_vert,
        ) do
          if settings.scrollbar.vert?
            scrollbar_char = ScrollbarHelper.vert_char(
              dimensions.children_height + dimensions.padding_height,
              canvas_coords.inner_grid_height,
              canvas_coords.top - canvas_coords.offset_content_top,
              row_within_cell
            )
            PADDING * canvas_coords.inner_grid_width + scrollbar_char
          else
            PADDING * canvas_coords.inner_grid_width
          end
        end
      end

      # Return the stroke for the horizontal scroll bar
      def bottom_scroll_stroke(canvas_coords)
        line_stroke(
          settings.border.style.left_vert,
          settings.border.style.middle_vert,
          settings.border.style.right_vert,
        ) do
          canvas_coords.inner_grid_width.times.map do |col_within_cell|
            ScrollbarHelper.horiz_char(
              dimensions.children_width + dimensions.padding_width,
              canvas_coords.inner_grid_width,
              canvas_coords.left - canvas_coords.offset_content_left,
              col_within_cell
            )
          end.join
        end
      end
    end
    private_constant :ContainerPainter
  end
end
