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
        # Determine the character to paint the horizontal scroll bar with for the given column
        #
        # @see #scroll_char for more details
        def horiz_char(col_count, viewable_col_count, first_visible_col, curr_col)
          scroll_char(col_count, viewable_col_count, first_visible_col, curr_col, HORIZONTAL)
        end

        # Determine the character to paint the vertical scroll bar with for the given row
        #
        # @see #scroll_char for more details
        def vert_char(row_count, viewable_row_count, first_visible_row, curr_row)
          scroll_char(row_count, viewable_row_count, first_visible_row, curr_row, VERTICAL)
        end

        private

        # Determine which character to paint a for a scrollbar
        #
        # @param total_count [Integer] total number of rows/columns in the content
        # @param viewable_count [Integer] number of rows/columns visible in the viewport
        # @param first_visible [Integer] zero-based index of the first row/column that is visible
        #   in the viewport
        # @param curr [Integer] zero-based index of the row/column (relative to the first visible
        #   row/column) that the painted character is being requested for
        # @param chars [Array<String>] an array with three 1-character strings, the frist is the
        #   "second half" scrollbar character, the second is the "full" scrollbar character, and
        #   the third is the "first half" scrollbar character.
        def scroll_char(total_count, viewable_count, first_visible, curr, chars)
          return chars[0] if total_count == 0
          return chars[0] if viewable_count == 0
          return chars[0] if viewable_count >= total_count

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
          scrollbar_length = (viewable_count ** 2).to_f / total_count

          # Round the length to the nearst "scaled" value
          scrollbar_length = (SCROLL_HANDLE_SCALE * scrollbar_length).round.to_f / SCROLL_HANDLE_SCALE

          # Ensure we have a scrollbar!
          scrollbar_length = 1.0 / SCROLL_HANDLE_SCALE if scrollbar_length == 0

          # Find the "ideal" position of where the scrollbar should start.
          scrollbar_start = first_visible * viewable_count.to_f / total_count

          # Round the start to the nearest "scaled" value
          scrollbar_start = (SCROLL_HANDLE_SCALE * scrollbar_start).round.to_f / SCROLL_HANDLE_SCALE

          # Make sure we didn't scroll off the page!
          scrollbar_start -= scrollbar_length if scrollbar_start == viewable_count

          # Create "scaled" indexes for the subdivided current character
          curr_0 = curr
          curr_1 = curr + 1.0 / SCROLL_HANDLE_SCALE

          first_half = scrollbar_start <= curr_0 && curr_0 < scrollbar_start + scrollbar_length ? 2 : 0
          second_half = scrollbar_start <= curr_1 && curr_1 < scrollbar_start + scrollbar_length ? 1 : 0

          chars[second_half | first_half]
        end
      end
    end
  end
end
