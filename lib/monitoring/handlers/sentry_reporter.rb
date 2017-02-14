module Monitoring
  module Handlers
    class SentryReporter
      def call(res)
        return unless res.error?

        event = "[#{app.name}][monitoring][#{res.name}][#{res.message}]"
        Raven.send_event(event)
      end

      private

      def app_name
        Monitoring.configuration.application_name
      end
    end
  end
end
