require 'logger'

require 'whirled_peas/errors'

require 'whirled_peas/config'
require 'whirled_peas/frame'
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
    require 'whirled_peas/template/element'

    template = UI::Template.new
    yield template, template.settings
    template
  end

  def self.print_title_fonts
    require 'whirled_peas/utils/title_font'

    Utils::TitleFont.fonts.keys.each do |key|
      puts Utils::TitleFont.to_s(key.to_s, key)
      puts key.inspect
      puts
    end
  end
end
