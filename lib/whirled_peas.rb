require 'logger'

require 'whirled_peas/errors'
require 'whirled_peas/config'
require 'whirled_peas/frame'
require 'whirled_peas/settings'
require 'whirled_peas/template'
require 'whirled_peas/ui'
require 'whirled_peas/utils'
require 'whirled_peas/version'

module WhirledPeas
  def self.config
    @config ||= Config.new
  end

  def self.configure(&block)
    yield config
  end

  def self.template(&block)
    require 'whirled_peas/template/composer'

    composer = Template::Composer.new
    yield composer, composer.element.settings
    composer.element
  end
end
