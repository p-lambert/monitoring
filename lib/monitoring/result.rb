require 'json'

module Monitoring
  class Result < Struct.new(:probe, :status, :message)
    def initialize(*)
      super
      freeze
    end

    def success?
      !!status
    end

    def failure?
      !success?
    end

    def same_probe?(other)
      other.respond_to?(:[]) && probe == other['probe']
    end

    def to_json(*args)
      to_h.to_json(*args)
    end
  end
end
