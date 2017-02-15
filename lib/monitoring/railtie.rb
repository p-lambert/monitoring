require 'monitoring'
require 'rails'

module Monitoring
  class Railtie < Rails::Railtie
    railtie_name :monitoring

    rake_tasks do
      load 'tasks/monitoring.rake'
    end
  end
end
