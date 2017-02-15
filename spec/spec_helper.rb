$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'monitoring'

RSpec.configure do |c|
  c.disable_monkey_patching!
end
