require_relative 'base'

module WhirledPeas
  module Command
    class Help < Base
      def self.description
        'Show detailed help for a command'
      end

      def start
        class_name = cmd.split('_').map(&:capitalize).join
        klass = Command.const_get(class_name)
        klass.print_usage
      rescue NameError
        puts "Unrecognized command: #{cmd}"
        exit(1)
      end

      private

      attr_reader :cmd

      def validate!
        super
        cmd = args.shift
        if cmd.nil?
          @error_text = "#{command_name} requires a command"
        else
          @cmd = cmd
        end
      end

      def options_usage
        [*super, '<command>'].join(' ')
      end
    end
  end
end
