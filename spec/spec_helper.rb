$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'monitoring'
require 'webmock/rspec'

RSpec.configure do |c|
  c.disable_monkey_patching!
end
