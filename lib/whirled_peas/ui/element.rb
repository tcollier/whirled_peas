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
        super(TextSettings.new.merge(settings))
      end

      def value=(val)
        @value = val
        @preferred_width = value.length
        @preferred_height = 1
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
        nil
      end

      def add_box(&block)
        element = BoxElement.new(settings)
        yield element, element.settings
        children << element
      end

      def add_grid(&block)
        element = GridElement.new(settings)
        yield element, element.settings
        children << element
      end
    end

    class Template < ComposableElement
      def initialize(settings=TemplateSettings.new)
        super(settings)
      end
    end

    class BoxElement < ComposableElement
      def initialize(settings)
        super(BoxSettings.new.merge(settings))
      end

      def preferred_width
        settings.margin.left +
          (settings.border.left? ? 1 : 0) +
          settings.padding.left +
          (children.map(&:preferred_width).sum || 0) +
          settings.padding.right +
          (settings.border.right? ? 1 : 0) +
          settings.margin.right
      end

      def preferred_height
        settings.margin.top +
          (settings.border.top? ? 1 : 0) +
          settings.padding.top +
          (children.map(&:preferred_height).max || 0) +
          settings.padding.bottom +
          (settings.border.bottom? ? 1 : 0) +
          settings.margin.bottom
      end
    end

    class GridElement < ComposableElement
      def initialize(settings)
        super(GridSettings.new.merge(settings))
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
    end
  end
end

# template = WhirledPeas.template do |template|
#   template.add_box do |header, settings|
#     settings.width = '100%'
#     header.add_text do |_, settings|
#       settings.bold = true
#       "Title"
#     end
#     header.add_text do
#       "Author"
#     end
#   end
#   template.add_grid do |grid, settings|
#     settings.num_cols = 4
#     20.times.map(&:to_s)
#   end
# end
