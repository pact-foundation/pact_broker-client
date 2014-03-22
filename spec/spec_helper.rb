require 'rspec/fire'

RSpec.configure do | config |
  config.include RSpec::Fire
end

require "./spec/support/shared_context.rb"

def silence_warnings
  old_verbose, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = old_verbose
end