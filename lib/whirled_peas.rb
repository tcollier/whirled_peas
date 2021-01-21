require 'logger'

require 'whirled_peas/frame'
require 'whirled_peas/ui'
require 'whirled_peas/version'

module WhirledPeas
  class Error < StandardError; end

  DEFAULT_REFRESH_RATE = 30

  LOGGER_ID = 'MAIN'

  def self.start(driver, template_factory, log_level: Logger::INFO, refresh_rate: DEFAULT_REFRESH_RATE)
    logger = Logger.new(File.open('whirled_peas.log', 'a'))
    logger.level = log_level
    logger.formatter = proc do |severity, datetime, progname, msg|
      if msg.is_a?(Exception)
        msg = %Q(#{msg.class}: #{msg.to_s}\n    #{msg.backtrace.join("\n    ")})
      end
      "[#{severity}] #{datetime.strftime('%Y-%m-%dT%H:%M:%S.%L')} (#{progname}) - #{msg}\n"
    end

    event_loop = Frame::EventLoop.new(template_factory, refresh_rate, logger)
    event_loop_thread = Thread.new do
      Thread.current.report_on_exception = false
      event_loop.start
    end

    Frame::Producer.produce(event_loop: event_loop, logger: logger) do |producer|
      begin
        driver.start(producer)
      rescue => e
        logger.warn(LOGGER_ID) { 'Driver exited with error, terminating producer...' }
        logger.error(LOGGER_ID) { e }
        raise
      end
    end

    event_loop_thread.join
  end

  def self.template(&block)
    template = UI::Template.new
    yield template, template.settings
    template
  end
end
