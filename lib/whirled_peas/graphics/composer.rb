require 'whirled_peas/settings/box_settings'
require 'whirled_peas/settings/graph_settings'
require 'whirled_peas/settings/grid_settings'
require 'whirled_peas/settings/text_settings'

require_relative 'box_painter'
require_relative 'graph_painter'
require_relative 'grid_painter'
require_relative 'text_painter'

module WhirledPeas
  module Graphics
    class Composer
      # List of classes that convert nicely to a string
      STRINGALBE_CLASSES = [FalseClass, Float, Integer, NilClass, String, Symbol, TrueClass]
      private_constant :STRINGALBE_CLASSES

      def self.stringable?(value)
        STRINGALBE_CLASSES.include?(value.class)
      end

      def self.next_name
        @counter ||= 0
        @counter += 1
        "Element-#{@counter}"
      end

      def self.build
        settings = Settings::BoxSettings.new
        template = BoxPainter.new('TEMPLATE', settings)
        composer = Composer.new(template)
        value = yield composer, settings
        if !template.children? && stringable?(value)
          composer.add_text { value.to_s }
        end
        template
      end

      attr_reader :painter

      def initialize(painter)
        @painter = painter
      end

      def add_text(name=self.class.next_name, &block)
        child_settings = Settings::TextSettings.inherit(painter.settings)
        child = TextPainter.new(name, child_settings)
        # TextPainters are not composable, so yield nil
        content = yield nil, child_settings
        child_settings.validate!
        unless self.class.stringable?(content)
          raise ArgumentError, "Unsupported type for text: #{content.class}"
        end
        child.content = content.to_s
        painter.add_child(child)
      end

      def add_graph(name=self.class.next_name, &block)
        child_settings = Settings::GraphSettings.inherit(painter.settings)
        child = GraphPainter.new(name, child_settings)
        # GraphPainters are not composable, so yield nil
        content = yield nil, child_settings
        child_settings.validate!
        unless content.is_a?(Array) && content.length > 0
          raise ArgumentError, 'Graphs require a non-empty array as the content'
        end
        child.content = content
        painter.add_child(child)
      end

      def add_box(name=self.class.next_name, &block)
        child_settings = Settings::BoxSettings.inherit(painter.settings)
        child = BoxPainter.new(name, child_settings)
        composer = self.class.new(child)
        value = yield composer, child.settings
        child_settings.validate!
        painter.add_child(child)
        if !child.children? && self.class.stringable?(value)
          composer.add_text("#{name}-Text") { value.to_s }
        end
      end

      def add_grid(name=self.class.next_name, &block)
        child_settings = Settings::GridSettings.inherit(painter.settings)
        child = GridPainter.new(name, child_settings)
        composer = self.class.new(child)
        values = yield composer, child.settings
        child_settings.validate!
        painter.add_child(child)
        if !child.children? && values.is_a?(Array)
          values.each.with_index do |value, index|
            composer.add_text("#{name}-Text-#{index}") { value.to_s }
          end
        end
      end
    end
  end
end
