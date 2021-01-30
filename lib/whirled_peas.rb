require 'whirled_peas/animator'
require 'whirled_peas/config'
require 'whirled_peas/errors'
require 'whirled_peas/graphics'
require 'whirled_peas/settings'
require 'whirled_peas/utils'
require 'whirled_peas/version'

module WhirledPeas
  def self.config
    @config ||= Config.new
  end

  def self.configure(&block)
    yield config
  end

  def self.template(theme_name=nil, &block)
    require 'whirled_peas/graphics/composer'
    Graphics::Composer.build(theme_name, &block)
  end

  def self.register_theme(name, &block)
    require 'whirled_peas/settings/theme'
    require 'whirled_peas/settings/theme_library'
    theme = Settings::Theme.new
    yield theme
    Settings::ThemeLibrary.add(name, theme)
  end
end
