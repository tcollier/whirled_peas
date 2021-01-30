require 'yaml'

require_relative 'theme'

module WhirledPeas
  module Settings
    module ThemeLibrary
      CONFIG_FILE = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'data', 'themes.yaml')

      class << self
        def theme_names
          themes.keys
        end

        def add(name, theme)
          themes[name] = theme
        end

        def get(name)
          unless themes.key?(name)
            expected = themes.keys.map(&:inspect).join(', ')
            raise ArgumentError, "Unknown theme: #{name.inspect}, expecting one of #{expected}"
          end
          themes[name]
        end

        def default_name
          themes.keys.first
        end

        private

        def themes
          return @themes if @themes
          @themes = {}
          config = YAML.load_file(CONFIG_FILE)
          config.each do |name, settings|
            name = name.to_sym
            theme = Theme.new
            settings.each do |key, value|
              case key
              when 'color'
                theme.color = value
              when 'bg_color'
                theme.bg_color = value
              when 'border_color'
                theme.border_color = value
              when 'axis_color'
                theme.axis_color = value
              when 'title_font'
                theme.title_font = value
              else
                raise ArgumentError, "Unexpected theme setting: #{key} in #{CONFIG_FILE}"
              end
            end
            @themes[name] = theme
          end
          @themes
        end
      end
    end
  end
end
