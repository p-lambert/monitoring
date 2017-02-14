require 'monitoring/version'

module Monitoring
  require_relative 'monitoring/configuration'
  require_relative 'monitoring/file_report'
  require_relative 'monitoring/probe'
  require_relative 'monitoring/result'
  require_relative 'monitoring/repositories'
  require_relative 'monitoring/runner'
  require_relative 'monitoring/route'

  SUCCESS = true
  FAILURE = false

  extend self
  attr_writer :configuration

  def probes
    @probes ||= Repositories::ProbeRepository.new
  end

  def handlers
    @handlers ||= Repositories::HandlerRepository.new
  end

  def report
    @report ||= FileReport.new
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield(configuration)
  end

  def add(name, callable = nil, handle_with: nil, &block)
    probes.add(name, callable, handle_with, &block)
  end

  def run
    setup && Runner.new.call
  end

  private

  def setup
    configuration && probes && handlers && report
  end

  require_relative 'monitoring/handlers'
end
