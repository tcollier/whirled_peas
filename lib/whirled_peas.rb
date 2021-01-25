require 'logger'

require 'whirled_peas/errors'
require 'whirled_peas/config'
require 'whirled_peas/frame'
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

  def self.template(&block)
    require 'whirled_peas/graphics/composer'
    Graphics::Composer.build(&block)
  end
end
