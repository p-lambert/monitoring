module Monitoring
  module Handlers
    class FileReporter
      def call(res)
        return unless res.is_a?(Result)

        Monitoring.report.write(res)
      end
    end
  end
end
