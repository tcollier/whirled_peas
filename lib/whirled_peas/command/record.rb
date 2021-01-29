require_relative 'config_command'

module WhirledPeas
  module Command
    class Record < ConfigCommand
      def self.description
        'Record animation to a file'
      end

      def start
        raise NotImplementedError
      end
    end
  end
end
