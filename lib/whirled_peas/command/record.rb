require_relative 'config_command'

module WhirledPeas
  module Command
    class Record < ConfigCommand
      def self.description
        'Record animation to a file'
      end

      def start
        super
        require 'highline'
        require 'whirled_peas/animator/renderer_consumer'
        require 'whirled_peas/animator/producer'
        require 'whirled_peas/device/output_file'

        width, height = HighLine.new.terminal.terminal_size
        consumer = Animator::RendererConsumer.new(
          WhirledPeas.config.template_factory,
          Device::OutputFile.new(out_file),
          width,
          height
        )
        Animator::Producer.produce(
          consumer, WhirledPeas.config.refresh_rate
        ) do |producer|
          config.application.start(producer)
        end
      end

      private

      attr_reader :out_file

      def validate!
        super
        return unless @error_text.nil?

        out_file = args.shift
        if out_file.nil?
          @error_text = "#{command_name} requires an output file"
        elsif !out_file.end_with?('.wpz')
          if out_file.split('/').last =~ /\./
            extra = ", found: .#{out_file.split('.').last}"
          end
          @error_text = "Expecting output file with .wpz extension#{extra}"
        else
          @out_file = out_file[0] == '/' ? out_file : File.join(Dir.pwd, out_file)
        end
      end

      def options_usage
        [*super, '<output file>'].join(' ')
      end
    end
  end
end
