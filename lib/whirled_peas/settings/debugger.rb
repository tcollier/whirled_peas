require_relative 'border'
require_relative 'container_settings'
require_relative 'margin'
require_relative 'padding'

module WhirledPeas
  module Settings
    class Debugger
      def initialize(settings)
        @settings = settings
      end

      def debug(indent='')
        values = non_default_values(indent + '  ')
        details = values.length > 0 ? values.join("\n") : "#{indent}  <default>"
        "#{indent}#{settings.class}\n#{details}"
      end

      private

      attr_reader :settings

      def non_default_values(indent)
        settings.instance_variables.map do |ivar, values|
          value = settings.instance_variable_get(ivar)
          next if value.nil?
          printable_value = debug_value(value)
          "#{indent}#{ivar.to_s.sub(/^@?_?/, '')}: #{printable_value}" unless printable_value.nil?
        end.compact
      end

      def debug_value(value)
        return if value.nil?
        case value
        when Margin
          margin_value(value)
        when Border
          border_value(value)
        when Padding
          padding_value(value)
        else
          value.inspect
        end
      end

      def non_defaults(object, default_object, keys)
        values = keys.map.with_object({}) do |key, hash|
          unless object.send(key) == default_object.send(key)
            hash[key] = object.send(key)
          end
        end
        values.keys.map { |k| "#{k}: #{values[k]}"}.join(', ')
      end

      def margin_value(margin)
        values = non_defaults(margin, Margin.new, %i[left top right bottom])
        return if values == ''
        "Margin(#{values})"
      end

      def border_value(border)
        values = non_defaults(
          border,
          Border.new,
          %i[left? top? right? bottom? inner_horiz? inner_vert? style color]
        )
        return if values == ''
        "Border(#{values})"
      end

      def padding_value(padding)
        values = non_defaults(padding, Padding.new, %i[left top right bottom])
        return if values == ''
        "Padding(#{values})"
      end
    end
  end
end
