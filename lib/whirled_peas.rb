require 'logger'

require 'whirled_peas/frame'
require 'whirled_peas/ui'
require 'whirled_peas/version'

module WhirledPeas
  class Error < StandardError; end

  DEFAULT_HOST = 'localhost'
  DEFAULT_PORT = 8765
  DEFAULT_REFRESH_RATE = 30

  LOGGER_ID = 'MAIN'

  def self.start(driver, template_factory, log_level: Logger::INFO, refresh_rate: DEFAULT_REFRESH_RATE, host: DEFAULT_HOST, port: DEFAULT_PORT)
    logger = Logger.new(File.open('whirled_peas.log', 'a'))
    logger.level = log_level
    logger.formatter = proc do |severity, datetime, progname, msg|
      if msg.is_a?(Exception)
        msg = %Q(#{msg.class}: #{msg.to_s}\n    #{msg.backtrace.join("\n    ")})
      end
      "[#{severity}] #{datetime.strftime('%Y-%m-%dT%H:%M:%S.%L')} (#{progname}) - #{msg}\n"
    end

    consumer = Frame::Consumer.new(template_factory, refresh_rate, logger)
    consumer_thread = Thread.new do
      Thread.current.report_on_exception = false
      consumer.start(host: host, port: port)
    end

    Frame::Producer.start(logger: logger, host: host, port: port) do |producer|
      begin
        driver.start(producer)
      rescue Errno::EPIPE
        # This error is typically raised when the consumer crashes. Joining the consumer
        # thread below will result in surfacing that error.
        logger.error(LOGGER_ID) { 'Producer cannot connect to consumer, exiting...' }
      rescue => e
        logger.warn(LOGGER_ID) { 'Driver exited with error, terminating producer...' }
        logger.error(LOGGER_ID) { e }
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
