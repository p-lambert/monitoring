module Monitoring
  module Handlers
    class SentryReporter
      def call(result)
        return unless result.failure?

        Raven.capture_message(
          "[monitoring][#{result.probe}] #{result.message}",
          level: 'warning',
          tags: {
            application: app_name
          }
        )
      end

      private

      def app_name
        Monitoring.configuration.application_name
      end
    end
  end
end
