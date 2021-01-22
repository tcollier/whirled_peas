require_relative '../utils/title_font'

require_relative 'settings'

module WhirledPeas
  module UI
    STRINGALBE_CLASSES = [FalseClass, Float, Integer, NilClass, String, Symbol, TrueClass]

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
      attr_reader :lines

      def initialize(name, settings)
        super(name, TextSettings.merge(settings))
      end

      def lines=(val)
        unless STRINGALBE_CLASSES.include?(val.class)
          raise ArgmentError, "Unsupported type for TextElement: #{val.class}"
        end
        if settings.title_font
          @lines = Utils::TitleFont.to_s(val.to_s, settings.title_font).split("\n")
        else
          @lines = [val.to_s]
        end
        @preferred_width = settings.width || @lines.first.length
        @preferred_height = @lines.length
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
        element.lines = yield nil, element.settings
        children << element
      end

      def add_box(name=self.class.next_name, &block)
        element = BoxElement.new(name, settings)
        value = yield element, element.settings
        children << element
        if element.children.empty? && STRINGALBE_CLASSES.include?(value.class)
          element.add_text { value.to_s }
        end
      end

      def add_grid(name=self.class.next_name, &block)
        element = GridElement.new(name, settings)
        values = yield element, element.settings
        children << element
        if element.children.empty? && values.is_a?(Array)
          values.each { |v| element.add_text { v.to_s } }
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

      private

      def margin_width
        settings.margin.left + settings.margin.right
      end

      def margin_height
        settings.margin.top + settings.margin.bottom
      end

      def outer_border_width
        (settings.border.left? ? 1 : 0) + (settings.border.right? ? 1 : 0)
      end

      def outer_border_height
        (settings.border.top? ? 1 : 0) + (settings.border.bottom? ? 1 : 0)
      end

      def inner_border_width
        settings.border.inner_vert? ? 1 : 0
      end

      def inner_border_height
        settings.border.inner_horiz? ? 1 : 0
      end

      def padding_width
        settings.padding.left + settings.padding.right
      end

      def padding_height
        settings.padding.top + settings.padding.bottom
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
        @preferred_width ||=
          margin_width + outer_border_width + padding_width + content_width
      end

      def content_height
        @content_height ||= begin
          child_heights = children.map(&:preferred_height)
          settings.vertical_flow? ? child_heights.sum : (child_heights.max || 0)
        end
      end

      def preferred_height
        @preferred_height ||=
          margin_height + outer_border_height + padding_height + content_height
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
        margin_width +
          outer_border_width +
          settings.num_cols * (padding_width + col_width) +
          (settings.num_cols - 1) * inner_border_width
      end

      def preferred_height
        num_rows = (children.length / settings.num_cols).ceil
        margin_height +
          outer_border_height +
          num_rows * (padding_height + row_height) +
          (num_rows - 1) * inner_border_height
      end
    end
  end
end
