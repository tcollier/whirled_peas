require_relative 'settings'

module WhirledPeas
  module UI
    class Element
      attr_accessor :preferred_width, :preferred_height
      attr_reader :name, :settings

      def initialize(name, settings)
        @name = name
        @settings = settings
      end
    end
    private_constant :Element

    class TextElement < Element
      attr_reader :value

      def initialize(name, settings)
        super(name, TextSettings.merge(settings))
      end

      def value=(val)
        @value = val
        @preferred_width = settings.width || value.length
        @preferred_height = 1
      end

      def inspect(indent='')
        dims = unless preferred_width.nil?
          "#{indent + '  '}- Dimensions: #{preferred_width}x#{preferred_height}"
        end
        [
          "#{indent}+ #{name} [#{self.class.name}]",
          dims,
          "#{indent + '  '}- Settings",
          settings.inspect(indent + '    ')
        ].compact.join("\n")
      end
    end

    class ComposableElement < Element
      class << self
        def next_name
          @counter ||= 0
          @counter += 1
          "Element-#{@counter}"
        end
      end

      def initialize(name, settings)
        super
      end

      def children
        @children ||= []
      end

      def add_text(name=self.class.next_name, &block)
        element = TextElement.new(name, settings)
        element.value = yield nil, element.settings
        children << element
      end

      def add_box(name=self.class.next_name, &block)
        element = BoxElement.new(name, settings)
        value = yield element, element.settings
        children << element
        if element.children.empty? && value.is_a?(String)
          element.add_text { value }
        end
      end

      def add_grid(name=self.class.next_name, &block)
        element = GridElement.new(name, settings)
        values = yield element, element.settings
        children << element
        if element.children.empty? && values.is_a?(Array)
          values.each { |v| element.add_text { v } }
        end
      end

      def inspect(indent='')
        kids = children.map { |c| c.inspect(indent + '    ') }.join("\n")
        dims = unless preferred_width.nil?
          "#{indent + '  '}- Dimensions: #{preferred_width}x#{preferred_height}"
        end
        [
          "#{indent}+ #{name} [#{self.class.name}]",
          dims,
          "#{indent + '  '}- Settings",
          settings.inspect(indent + '    '),
          "#{indent + '  '}- Children",
          kids
        ].compact.join("\n")
      end
    end

    class Template < ComposableElement
      def initialize(settings=TemplateSettings.new)
        super('TEMPLATE', settings)
      end
    end

    class BoxElement < ComposableElement
      attr_writer :content_width, :content_height

      def initialize(name, settings)
        super(name, BoxSettings.merge(settings))
      end

      def self.from_template(template, width, height)
        box = new(template.name, template.settings)
        template.children.each { |c| box.children << c }
        box.content_width = box.preferred_width = width
        box.content_height = box.preferred_height = height
        box
      end

      def content_width
        @content_width ||= begin
          child_widths = children.map(&:preferred_width)
          width = settings.horizontal_flow? ? child_widths.sum : (child_widths.max || 0)
          [width, *settings.width].max
        end
      end

      def preferred_width
        @preferred_width ||= settings.margin.left +
          (settings.border.left? ? 1 : 0) +
          settings.padding.left +
          content_width +
          settings.padding.right +
          (settings.border.right? ? 1 : 0) +
          settings.margin.right
      end

      def content_height
        @content_height ||= begin
          child_heights = children.map(&:preferred_height)
          settings.vertical_flow? ? child_heights.sum : (child_heights.max || 0)
        end
      end

      def preferred_height
        @preferred_height ||= settings.margin.top +
          (settings.border.top? ? 1 : 0) +
          settings.padding.top +
          content_height +
          settings.padding.bottom +
          (settings.border.bottom? ? 1 : 0) +
          settings.margin.bottom
      end
    end

    class GridElement < ComposableElement
      def initialize(name, settings)
        super(name, GridSettings.merge(settings))
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
