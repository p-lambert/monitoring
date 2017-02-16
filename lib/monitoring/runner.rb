module Monitoring
  class Runner
    def initialize(probes = Monitoring.probes, handlers = Monitoring.handlers)
      @probe_repository = probes.to_enum
      @handler_repository = handlers
    end

    def call
      threaded_probes = probe_repository.map do |name, (task, *handlers)|
        handlers = ensure_handlers(handlers)
        Thread.new { Probe.new(name, task, *handlers).call }
      end

      threaded_probes.each(&:join)
    end

    private

    attr_reader :probe_repository, :handler_repository

    def ensure_handlers(handlers)
      handlers = (handlers.any? && handlers) || handler_repository.keys

      handler_repository.values_at(*handlers).compact
    end
  end
end
