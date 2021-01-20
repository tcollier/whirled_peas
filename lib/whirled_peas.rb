require 'whirled_peas/frame'
require 'whirled_peas/ui'
require 'whirled_peas/version'

module WhirledPeas
  class Error < StandardError; end

  DEFAULT_HOST = 'localhost'
  DEFAULT_PORT = 8765
  DEFAULT_REFRESH_RATE = 30

  def self.start(driver, template_factory, refresh_rate: DEFAULT_REFRESH_RATE, host: DEFAULT_HOST, port: DEFAULT_PORT)
    consumer = Frame::Consumer.new(template_factory, refresh_rate)
    consumer_thread = Thread.new { consumer.start(host: host, port: port) }

    Frame::Producer.start(host: host, port: port) do |producer|
      begin
        driver.start(producer)
        producer.stop
      rescue
        producer.terminate
        raise
      end
    end

    consumer_thread.join
  end

  def self.template(&block)
    template = UI::Template.new
    yield template, template.settings
    template
  end
end
