require 'tempfile'

module Monitoring
  class Configuration
    attr_accessor :application_name, :output_file, :timeout

    def application_name
      @application_name ||= 'application_name'
    end

    def output_file
      @output_file ||= Tempfile.new('monitoring.json')
    end

    def timeout
      @timeout ||= 10
    end

    def add_handler(name, callable)
      Monitoring.handlers.add(name, callable)
    end

    def remove_handler(name)
      Monitoring.handlers.remove(name)
    end
  end
end
