module Monitoring
  module Handlers
    class SentryReporter
      def call(result)
        return unless result.failure?

        Raven.send_event(event(result))
      end

      private

      def event(result)
        "[monitoring][app=#{app_name} #{result}]"
      end

      def app_name
        Monitoring.configuration.application_name
      end
    end
  end
end
