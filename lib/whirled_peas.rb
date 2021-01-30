require 'whirled_peas/animator'
require 'whirled_peas/config'
require 'whirled_peas/errors'
require 'whirled_peas/graphics'
require 'whirled_peas/settings'
require 'whirled_peas/utils'
require 'whirled_peas/version'

module WhirledPeas
  class << self
    def configure(&block)
      yield config
    end

    def template(theme_name=nil, &block)
      require 'whirled_peas/graphics/composer'
      Graphics::Composer.build(theme_name, &block)
    end

    def register_theme(name, &block)
      require 'whirled_peas/settings/theme'
      require 'whirled_peas/settings/theme_library'
      theme = Settings::Theme.new
      yield theme
      Settings::ThemeLibrary.add(name, theme)
    end

    private

    def config
      @config ||= Config.new
    end
  end
end
