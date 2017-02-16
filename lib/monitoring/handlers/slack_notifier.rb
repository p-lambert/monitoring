require_relative 'poster'

module Monitoring
  module Handlers
    class SlackNotifier < Poster
      private

      def body(result)
        {
          username: username(result),
          icon_emoji: emoji(result),
          text: text(result)
        }
      end

      def username(result)
        "#{result.probe} (#{app_name})"
      end

      def emoji(result)
        (result.success? && ':white_check_mark:') || ':x:'
      end

      def text(result)
        "#{result.message}"
      end

      def app_name
        Monitoring.configuration.application_name
      end
    end
  end
end
