require 'monitoring'

namespace :monitoring do
  desc 'Run all monitoring probes'
  task run: :environment do
    Monitoring.run
  end
end
