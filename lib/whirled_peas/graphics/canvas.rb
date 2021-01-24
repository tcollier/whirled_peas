require 'whirled_peas/utils/formatted_string'

module WhirledPeas
  module Graphics
    # Canvas represent the area of the screen a painter can paint on.
    class Canvas
      attr_reader :left, :top, :width, :height

      def self.unwritable
        new(-1, -1, 0, 0)
      end

      def initialize(left, top, width, height)
        @left = left
        @top = top
        @width = width
        @height = height
      end

      def writable?
        width > 0 || height > 0
      end

      def child(child_left, child_top, child_width, child_height)
        if child_left >= left + width
          self.class.unwritable
        elsif child_left + child_width <= left
          self.class.unwritable
        elsif child_top >= top + height
          self.class.unwritable
        elsif child_top + child_height <= top
          self.class.unwritable
        else
          if child_left < left
            child_width -= left - child_left
            child_left = left
          end
          child_width = [width - (child_left - left), child_width].min
          if child_top < top
            child_height -= top - child_top
            child_top = top
          end
          child_height = [height - (child_top - top), child_height].min
          self.class.new(child_left, child_top, child_width, child_height)
        end
      end

      # Yields a single line of formatted characters positioned on the canvas,
      # verifying only characters within the canvas are included.
      def stroke(stroke_left, stroke_top, raw, formatting=[], &block)
        if stroke_left >= left + width
          # The stroke starts to the right of the canvas
          fstring = Utils::FormattedString.blank
        elsif stroke_left + raw.length <= left
          # The stroke ends to the left of the canvas
          fstring = Utils::FormattedString.blank
        elsif stroke_top < top
          # The stroke is above the canvas
          fstring = Utils::FormattedString.blank
        elsif stroke_top >= top + height
          # The stroke is below the canvas
          fstring = Utils::FormattedString.blank
        else
          # In this section, we know that at least part of the stroke should be visible
          # on the canvas. Chop off parts of the raw string that aren't within the
          # canvas boundary and ensure the stroke start position is also within the
          # canvas boundary

          # If the stroke starts to the left of the canvas, set the start index to the
          # first value that will be on the canvas, then update stroke_left to be on
          # the canvas
          start_index = stroke_left < left ? left - stroke_left : 0
          stroke_left = left if stroke_left <= left

          # Determine how many characters from the stroke will fit on the canvas
          visible_length = [raw.length, width - (stroke_left - left)].min
          end_index = start_index + visible_length - 1
          fstring = Utils::FormattedString.new(raw[start_index..end_index], formatting)
        end
        yield stroke_left, stroke_top, fstring
      end

      def hash
        [left, top, width, height].hash
      end

      def ==(other)
        other.is_a?(self.class) && hash == other.hash
      end

      def inspect
        "Canvas(left=#{left}, top=#{top}, width=#{width}, height=#{height})"
      end
    end
  end
end
