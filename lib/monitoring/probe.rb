require 'timeout'

module Monitoring
  class Probe
    def initialize(name, task, *handlers)
      @name = name
      @task = task
      @handlers = handlers
    end

    def call
      handlers.each_with_object(run_task) do |handler, result|
        handler.call(result) rescue next
      end
    end

    private

    attr_reader :name, :task, :handlers

    def run_task
      data = with_timeout { task.call }

      Result.generate(name, data)
    rescue => e
      Result.new(name, FAILURE, e.message)
    end

    def with_timeout(limit = Monitoring.configuration.timeout)
      Timeout::timeout(limit) { yield }
    end
  end
end
