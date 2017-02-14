require 'logger'

module Monitoring
  module Handlers
    class Logger
      def call(res)
        level = res.status ? :info : :error

        logger.public_send(level, res.message)
      end

      private

      def logger
        rails_logger || ruby_logger
      end

      def rails_logger(status)
        return unless defined?(Rails)

        Rails.logger
      end

      def ruby_logger
        Logger.new(STDERR)
      end
    end
  end
end
