require 'whirled_peas/settings/debugger'

require_relative 'container'
require_relative 'text_element'

module WhirledPeas
  module Template
    class Debugger
      def initialize(element)
        @element = element
      end

      def debug(indent='')
        info = [
          "#{indent}* #{element.class}(#{element.name})",
        ]
        if element.is_a?(TextElement)
          info << "#{indent + '  '}- Content: #{element.content}"
        end
        info << "#{indent + '  '}- Settings"
        info << Settings::Debugger.new(element.settings).debug(indent + '    ')
        if element.is_a?(Container)
          info << "#{indent + '  '}- Children"
          info += element.each_child.map { |c| Debugger.new(c).debug(indent + '    ') }
        end
        info.join("\n")
      end

      private

      attr_reader :element
    end
  end
end
