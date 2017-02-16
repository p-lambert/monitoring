require_relative 'poster'

module Monitoring
  module Handlers
    class SlackNotifier < Poster
      private

      def body(result)
        { username: username, icon: icon(result), text: text(result) }
      end

      def username
        "vestorly-monitoring (#{app_name})"
      end

      def icon(result)
        (result.success? && ':white_check_mark:') || ':x:'
      end

      def text(result)
        "[#{result.probe}]\n#{result.message}"
      end

      def app_name
        Monitoring.configuration.application_name
      end
    end
  end
end
