require_relative 'settings'

module WhirledPeas
  module UI
    class Element
      attr_reader :settings, :preferred_width, :preferred_height

      def initialize(settings)
        @settings = settings
      end
    end
    private_constant :Element

    class TextElement < Element
      attr_reader :value

      def initialize(settings)
        super(TextSettings.merge(settings))
      end

      def value=(val)
        @value = val
        @preferred_width = settings.width || value.length
        @preferred_height = 1
      end

      def inspect(indent='')
        dims = unless preferred_width.nil?
          "#{indent + '  '}Dimensions: #{preferred_width}x#{preferred_height}"
        end
        [
          "#{indent}#{self.class.name}",
          dims,
          "#{indent + '  '}Settings",
          settings.inspect(indent + '    ')
        ].compact.join("\n")
      end
    end

    class ComposableElement < Element
      def initialize(settings)
        super
      end

      def children
        @children ||= []
      end

      def add_text(&block)
        element = TextElement.new(settings)
        element.value = yield nil, element.settings
        children << element
      end

      def add_box(&block)
        element = BoxElement.new(settings)
        value = yield element, element.settings
        children << element
        if element.children.empty? && value.is_a?(String)
          element.add_text { value }
        end
      end

      def add_grid(&block)
        element = GridElement.new(settings)
        values = yield element, element.settings
        children << element
        if element.children.empty? && values.is_a?(Array)
          values.each { |v| element.add_text { v } }
        end
      end

      def inspect(indent='')
        kids = children.map { |c| c.inspect(indent + '    ') }.join("\n")
        dims = unless preferred_width.nil?
          "#{indent + '  '}Dimensions: #{preferred_width}x#{preferred_height}"
        end
        [
          "#{indent}#{self.class.name}",
          dims,
          "#{indent + '  '}Settings",
          settings.inspect(indent + '    '),
          "#{indent + '  '}Children",
          kids
        ].compact.join("\n")
      end
    end

    class Template < ComposableElement
      def initialize(settings=TemplateSettings.new)
        super(settings)
      end
    end

    class BoxElement < ComposableElement
      def initialize(settings)
        super(BoxSettings.merge(settings))
      end

      def content_width
        child_widths = children.map(&:preferred_width)
        width = settings.display_flow == :inline ? child_widths.sum : (child_widths.max || 0)
        [width, *settings.width].max
      end

      def preferred_width
        settings.margin.left +
          (settings.border.left? ? 1 : 0) +
          settings.padding.left +
          content_width +
          settings.padding.right +
          (settings.border.right? ? 1 : 0) +
          settings.margin.right
      end

      def content_height
        child_heights = children.map(&:preferred_height)
        settings.display_flow == :inline ? (child_heights.max || 0) : child_heights.sum
      end

      def preferred_height
        settings.margin.top +
          (settings.border.top? ? 1 : 0) +
          settings.padding.top +
          content_height +
          settings.padding.bottom +
          (settings.border.bottom? ? 1 : 0) +
          settings.margin.bottom
      end
    end

    class GridElement < ComposableElement
      def initialize(settings)
        super(GridSettings.merge(settings))
      end

      def col_width
        return @col_width if @col_width
        @col_width = 0
        children.each do |child|
          @col_width = child.preferred_width if child.preferred_width > @col_width
        end
        @col_width
      end

      def row_height
        return @row_height if @row_height
        @row_height = 0
        children.each do |child|
          @row_height = child.preferred_height if child.preferred_height > @row_height
        end
        @row_height
      end


      def preferred_width
        settings.margin.left +
          (settings.border.left? ? 1 : 0) +
          settings.num_cols * (
            settings.padding.left +
            col_width +
            settings.padding.right
          ) +
          (settings.num_cols - 1) * (settings.border.inner_vert? ? 1 : 0) +
          (settings.border.right? ? 1 : 0) +
          settings.margin.right
      end

      def preferred_height
        num_rows = (children.length / settings.num_cols).ceil
        settings.margin.top +
          (settings.border.top? ? 1 : 0) +
          num_rows * (
            settings.padding.top +
            row_height +
            settings.padding.bottom
          ) +
          (num_rows - 1) * (settings.border.inner_horiz? ? 1 : 0) +
          (settings.border.bottom? ? 1 : 0) +
          settings.margin.bottom
      end
    end
  end
end
