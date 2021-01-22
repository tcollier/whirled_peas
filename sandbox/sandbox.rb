require 'bundler/setup'
require 'whirled_peas'
require 'whirled_peas/ui/screen'

module WhirledPeas
  def self.sandbox(&block)
    template = WhirledPeas.template(&block)
    if ARGV.last == '--debug'
      puts template.inspect
      screen = UI::Screen.new(false)
    else
      screen = UI::Screen.new
    end
    screen.paint(template)
    screen.finalize
  end
end
