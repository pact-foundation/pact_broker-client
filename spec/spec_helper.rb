require 'rspec/fire'

RSpec.configure do | config |
  config.include RSpec::Fire
end

def silence_warnings
  old_verbose, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = old_verbose
end