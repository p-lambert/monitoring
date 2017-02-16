require 'logger'

module Monitoring
  module Handlers
    class Logger
      def call(res)
        logger.public_send(log_level(res), log_event(res))
      end

      private

      def log_level(result)
        (result.success? && :info) || :error
      end

      def log_event(result)
        "[monitoring][app=#{app_name} #{result}]"
      end

      def logger
        rails_logger || ruby_logger
      end

      def rails_logger
        defined?(Rails) && Rails.logger
      end

      def ruby_logger
        ::Logger.new(STDOUT)
      end

      def app_name
        Monitoring.configuration.application_name
      end
    end
  end
end
