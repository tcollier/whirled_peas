require_relative 'base'

module WhirledPeas
  module Command
    # Start the animation
    class Play < Base
      class NullPlayer
        def play
        end
      end

      class ApplicationPlayer
        def initialize(app_config_file, config, logger)
          @app_config_file = app_config_file
          @config = config
          @logger = logger
        end

        def play
          require app_config_file

          require 'whirled_peas/frame/event_loop'
          require 'whirled_peas/frame/producer'

          consumer = Frame::EventLoop.new(
            config.template_factory,
            logger: logger
          )
          Frame::Producer.produce(consumer, logger) do |producer|
            config.driver.start(producer)
          end
        end

        private

        attr_reader :app_config_file, :config, :logger
      end

      class FilePlayer
        def initialize(fgz_file)
          @fgz_file = fgz_file
        end

        def play
          raise NotImplementedError
        end

        private

        attr_reader :fgz_file
      end

      def self.description
        'Play an animation from an application or prerecorded file'
      end

      def start
        super
        player.play
      end

      private

      attr_reader :player

      def validate!
        super
        @player = NullPlayer
        file = args.shift
        if file.nil?
          @error_text = "#{command_name} requires an config file or frames file file"
        elsif !File.exist?(file)
          @error_text = "File not found: #{file}"
        else
          full_path_file = file[0] == '/' ? file : File.join(Dir.pwd, file)
          if full_path_file.end_with?('.fgz')
            @player = FilePlayer.new(full_path_file)
          elsif full_path_file.end_with?('.rb')
            @player = ApplicationPlayer.new(full_path_file, config, build_logger)
          else
            @error_text = "Unsupported file type: .#{file.split('.').last}, epxecting .rb or .fgz"
          end
        end
      end

      def options_usage
        '<config/fgz file>'
      end
    end
  end
end
