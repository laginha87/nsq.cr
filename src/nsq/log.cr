require "logger"

module NSQ
  class Log
    private def self.initialize_logger
      logger = Logger.new(STDOUT)
      logger.level = Logger::ERROR
      logger
    end

    @@logger : Logger = initialize_logger

    def self.logger
      @@logger
    end
  end
end
