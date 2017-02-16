module Monitoring
  class Runner
    def initialize(probes = Monitoring.probes, handlers = Monitoring.handlers)
      @probes = probes.to_enum
      @handlers = handlers
    end

    def call
      threaded_probes = probes.map do |name, (task, *handler_names)|
        handler_procs = resolve_handlers(handler_names)
        Thread.new { Probe.new(name, task, *handler_procs).call }
      end

      threaded_probes.each(&:join)
    end

    private

    attr_reader :probes, :handlers

    def resolve_handlers(names)
      names = handlers.keys unless names.any?

      handlers.values_at(*names).compact
    end
  end
end
