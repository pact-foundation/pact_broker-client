require 'rspec/fire'

RSpec.configure do | config |
  config.include RSpec::Fire
end

require "./spec/support/shared_context.rb"
