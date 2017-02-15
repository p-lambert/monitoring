module Monitoring
  module Handlers
    require_relative 'handlers/sentry_reporter'
    require_relative 'handlers/file_reporter'
    require_relative 'handlers/logger'
    require_relative 'handlers/poster'
    require_relative 'handlers/slack_notifier'

    Monitoring.configure do |config|
      config.add_handler(:logger, Handlers::Logger.new)
      config.add_handler(:report, Handlers::FileReporter.new)
    end
  end
end
