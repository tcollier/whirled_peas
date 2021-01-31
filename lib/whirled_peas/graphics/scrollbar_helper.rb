module WhirledPeas
  module Graphics
    module ScrollbarHelper
      # Contants to paint scrollbars
      HORIZONTAL = [' ', '▗', '▖', '▄']
      VERTICAL = [
        ' ',
        '▗',
        '▝',
        '▐'
      ]

      # The number of units of scrollbar a single character can be divided into
      SCROLL_HANDLE_SCALE = 2
      private_constant :SCROLL_HANDLE_SCALE

      class << self
        # Return the characters to paint the horizontal scroll bar with for the given column
        #
        # @see #scroll_chars for more details
        def horiz(col_count, viewable_col_count, first_visible_col)
          scroll_chars(col_count, viewable_col_count, first_visible_col, HORIZONTAL)
        end

        # Return the characters to paint the vertical scroll bar with for the given row
        #
        # @see #scroll_chars for more details
        def vert(row_count, viewable_row_count, first_visible_row)
          scroll_chars(row_count, viewable_row_count, first_visible_row, VERTICAL)
        end

        private

        # Determine which character to paint a for a scrollbar
        #
        # @param total_count [Integer] total number of rows/columns in the content
        # @param viewable_count [Integer] number of rows/columns visible in the viewport
        # @param first_visible [Integer] zero-based index of the first row/column that is visible
        #   in the viewport
        # @param chars [Array<String>] an array with four 1-character strings, the frist is the
        #   gutter (i.e. no scrolbar handle visible), then the "second half" scrollbar character,
        #   then second is the "first half" scrollbar character, and finally the "full"
        def scroll_chars(total_count, viewable_count, first_visible, chars)
          # Start by initializing the scroll back to to all gutters
          scrollbar = Array.new(viewable_count) { chars[0] }

          return scrollbar if total_count == 0
          return scrollbar if viewable_count == 0
          return scrollbar if viewable_count >= total_count

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
          #
          # Returning to the first example, we can match up the arguments to this method to the
          # diagram
          #
          #                       total_count = 50
          #    |<----------------------------------------------->|
          #    |                                                 |
          #    |                veiwable_count = 20              |
          #    |               |<----------------->|             |
          #    ↓               ↓                   ↓             ↓
          #    +---------1-----****2*********3******---4---------+
          #    |               *                   *             |
          #    |   hidden      *     viewable      *   hidden    |
          #    |               *                   *             |
          #    +---------1-----****2*********3******---4---------+
          #                    |......****?***.....|
          #                    ↑          ↑
          #      first_visible = 16       |
          #                             curr = 11

          # Always use the same length for the scrollbar so it does not give an inchworm effect
          # as it scrolls along. This will calculate the "ideal" length of the scroll bar if we
          # could infinitely divide a character.
          length = (viewable_count ** 2).to_f / total_count

          # Round the length to the nearst "scaled" value
          length = (SCROLL_HANDLE_SCALE * length).round.to_f / SCROLL_HANDLE_SCALE

          # Ensure we have a scrollbar!
          length = 1.0 / SCROLL_HANDLE_SCALE if length == 0

          # Find the "ideal" position of where the scrollbar should start.
          start = first_visible * viewable_count.to_f / total_count

          # Round the start to the nearest "scaled" value
          start = (SCROLL_HANDLE_SCALE * start).round.to_f / SCROLL_HANDLE_SCALE

          # Make sure we didn't scroll off the page!
          start -= length if start == viewable_count

          (start.floor..[(start + length).floor, viewable_count - 1].min).each do |curr_0|
            curr_1 = curr_0 + 1.0 / SCROLL_HANDLE_SCALE

            first_half = start <= curr_0 && curr_0 < start + length ? 2 : 0
            second_half = start <= curr_1 && curr_1 < start + length ? 1 : 0

            scrollbar[curr_0] = chars[second_half | first_half]
          end
          scrollbar
        end
      end
    end
  end
end
