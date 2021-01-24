require 'whirled_peas/settings/box_settings'
require 'whirled_peas/settings/grid_settings'
require 'whirled_peas/settings/text_settings'

require_relative 'box_element'
require_relative 'grid_element'
require_relative 'text_element'

module WhirledPeas
  module Template
    class Composer
      def self.next_name
        @counter ||= 0
        @counter += 1
        "Element-#{@counter}"
      end

      def self.build
        settings = Settings::BoxSettings.new
        template = BoxElement.new('TEMPLATE', settings)
        composer = Template::Composer.new(template)
        value = yield composer, settings
        if !template.children? && TextElement.stringable?(value)
          composer.add_text { value.to_s }
        end
        template
      end

      attr_reader :element

      def initialize(element)
        @element = element
      end

      def add_text(name=self.class.next_name, &block)
        child_settings = Settings::TextSettings.inherit(element.settings)
        child = TextElement.new(name, child_settings)
        # TextElements are not composable, so yield nil
        child.content = yield nil, child_settings
        element.add_child(child)
      end

      def add_box(name=self.class.next_name, &block)
        child_settings = Settings::BoxSettings.inherit(element.settings)
        child = BoxElement.new(name, child_settings)
        composer = self.class.new(child)
        value = yield composer, child.settings
        element.add_child(child)
        if !child.children? && TextElement.stringable?(value)
          composer.add_text("#{name}-Text") { value.to_s }
        end
      end

      def add_grid(name=self.class.next_name, &block)
        child_settings = Settings::GridSettings.inherit(element.settings)
        child = GridElement.new(name, child_settings)
        composer = self.class.new(child)
        values = yield composer, child.settings
        element.add_child(child)
        if !child.children? && values.is_a?(Array)
          values.each.with_index do |value, index|
            composer.add_text("#{name}-Text-#{index}") { value.to_s }
          end
        end
      end
    end
  end
end
