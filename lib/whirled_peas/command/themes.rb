require 'whirled_peas/device/screen'
require 'whirled_peas/graphics/renderer'
require 'whirled_peas/settings/theme_library'

require_relative 'base'

module WhirledPeas
  module Command
    # Display a still frame with the specified arguments.
    class Themes < Base
      def self.description
        'List all themes with sample template rendered in the theme'
      end

      def start
        super

        require config_file unless config_file.nil?

        theme_names = Settings::ThemeLibrary.theme_names
        theme_names.each.with_index do |name, index|
          template = WhirledPeas.template(name) do |composer, settings|
            settings.full_border
            settings.flow = :t2b
            composer.add_text do |_, settings|
              settings.title_font = :theme
              name
            end
            composer.add_text do
              name == Settings::ThemeLibrary.default_name ? ' (default)' : ''
            end
            composer.add_graph do |_, settings|
              settings.height = 12
              20.times.map { |i| Math.sqrt(i) }
            end
          end
          Utils::Ansi.with_screen do |width, height|
            rendered = Graphics::Renderer.new(
              template,
              80,
              30
            ).paint
            Device::Screen.new(10000).handle_renders([rendered])
          end

          if index < theme_names.length - 1
            print 'See next theme? [Y/q] '
            STDOUT.flush
            break if gets.chomp == 'q'
          end
        end
      rescue LoadError => e
        puts e
        puts e.backtrace.join("\n")
        exit(1)
      end

      private

      attr_reader :config_file

      def validate!
        super
        config_file = args.shift
        @error_text = 'hi'
        unless config_file.nil?
          # We think we have a valid ruby config file, set the absolute path to @config
          @config_file = config_file[0] == '/' ? config_file : File.join(Dir.pwd, config_file)
        end
      end

      def options_usage
        '[config file]'
      end
    end
  end
end
