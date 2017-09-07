require 'rspec/fire'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do | config |
  config.include RSpec::Fire
end

require "./spec/support/shared_context.rb"
