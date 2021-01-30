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

    def register_component(name, klass)
      require 'whirled_peas/component'
      Component::Factory.register(name, klass)
    end

    def component(composer, settings, name, &block)
      require 'whirled_peas/component'
      component = Component::Factory.build(name)
      yield component
      component.compose(composer, settings)
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

    def config
      @config ||= Config.new
    end
  end
end
