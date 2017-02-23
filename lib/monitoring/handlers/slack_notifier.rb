require_relative 'poster'

module Monitoring
  module Handlers
    class SlackNotifier < Poster
      private

      def body(result)
        { username: app_name, text: text(result), mrkdwn: true }
      end

      def emoji(result)
        (result.success? && ':white_check_mark:') || ':x:'
      end

      def text(result)
        msg = "#{emoji(result)} *[#{result.probe}]* #{result.message}"
        msg += ' <!here>' if result.failure?

        msg
      end

      def app_name
        Monitoring.configuration.application_name
      end
    end
  end
end
