require_relative 'poster'

module Monitoring
  module Handlers
    class SlackNotifier < Poster
      def initialize(*)
        super
        @channel = options.delete(:channel) || '#deploys'
      end

      private

      attr_reader :channel

      def body(result)
        {
          username: username,
          channel: channel,
          icon: icon(result),
          text: text(result)
        }
      end

      def username
        "vestorly-monitoring (#{Monitoring.configuration.application_name})"
      end

      def icon(result)
        return ':x:' unless result.success?

        ':white_check_mark:'
      end

      def text(result)
        "[#{result.probe}]\n#{result.message}"
      end
    end
  end
end
