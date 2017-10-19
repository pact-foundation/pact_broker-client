require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

require "./spec/support/shared_context.rb"
