require 'whirled_peas/frame'
require 'whirled_peas/ui'
require 'whirled_peas/version'

module WhirledPeas
  class Error < StandardError; end

  DEFAULT_HOST = 'localhost'
  DEFAULT_PORT = 8765

  def self.start(application, template_builder, host: DEFAULT_HOST, port: DEFAULT_PORT)
    consumer = Frame::Consumer.new(template_builder)
    consumer_thread = Thread.new { consumer.start(host: host, port: port) }

    Frame::Producer.start(host: host, port: port) do |producer|
      application.start(producer)
      producer.stop
    end

    consumer_thread.join
  end

  def self.template(&block)
    template = UI::Template.new
    yield template, template.settings
    template
  end
end
