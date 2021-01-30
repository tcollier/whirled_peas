
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

          require 'whirled_peas/animator/renderer_consumer'
          require 'whirled_peas/animator/producer'
          require 'whirled_peas/device/screen'
          require 'whirled_peas/utils/ansi'

          Utils::Ansi.with_screen do |width, height|
            consumer = Animator::RendererConsumer.new(
              WhirledPeas.config.template_factory,
              Device::Screen.new(WhirledPeas.config.refresh_rate),
              width,
              height
            )
            Animator::Producer.produce(
              consumer, WhirledPeas.config.refresh_rate
            ) do |producer|
              config.application.start(producer)
            end
          end
        rescue LoadError => e
          puts e
          puts e.backtrace.join("\n")
          exit(1)
        end

        private

        attr_reader :app_config_file, :config, :logger
      end

      class FilePlayer
        def initialize(wpz_file)
          @wpz_file = wpz_file
        end

        def play
          require 'whirled_peas/device/screen'
          require 'whirled_peas/utils/ansi'
          require 'whirled_peas/utils/file_handler'

          Utils::Ansi.with_screen do
            screen = Device::Screen.new(WhirledPeas.config.refresh_rate)
            renders = Utils::FileHandler.read(wpz_file)
            screen.handle_renders(renders)
          end
        end

        private

        attr_reader :wpz_file
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
          if full_path_file.end_with?('.wpz')
            @player = FilePlayer.new(full_path_file)
          elsif full_path_file.end_with?('.rb')
            @player = ApplicationPlayer.new(full_path_file, config, build_logger)
          else
            @error_text = "Unsupported file type: .#{file.split('.').last}, epxecting .rb or .wpz"
          end
        end
      end

      def options_usage
        '<config/wpz file>'
      end
    end
  end
end
