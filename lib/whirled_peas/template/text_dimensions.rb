module WhirledPeas
  module Template
    class TextDimensions
      attr_reader *%i[
        content_width
        content_height
        outer_width
        outer_height
        num_cols
        num_rows
      ]

      def initialize(content_width, content_height)
        @content_width = content_width
        @content_height = content_height
        @outer_width = content_width
        @outer_height = content_height
        @num_cols = 1
        @num_rows = 1
      end
    end
  end
end
