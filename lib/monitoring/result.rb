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

    def to_s
      "probe=#{probe} status=#{status} message=#{message}"
    end

    def to_h(*)
      { probe.to_s => { 'status' => status, 'message' => message } }
    end
    alias_method :to_hash, :to_h

    def self.generate(name, data)
      case data
      when Result then data
      when RESULT_PAIR then new(name, !!data[0], data[1])
      when nil, false, '' then new(name, FAILURE, 'FAILED')
      when String then new(name, SUCCESS, data)
      else new(name, SUCCESS, 'OK')
      end
    end

    RESULT_PAIR = lambda do |data|
      data.is_a?(Array) && data.size == 2 && data.last.is_a?(String)
    end
    private_constant :RESULT_PAIR
  end
end
