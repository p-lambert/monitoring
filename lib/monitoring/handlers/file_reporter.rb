module Monitoring
  module Handlers
    class FileReporter
      def call(result)
        Monitoring.report.write(result)
      end
    end
  end
end
