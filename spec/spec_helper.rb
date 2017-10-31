require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

require "./spec/support/shared_context.rb"

RSpec.configure do | config |

  config.before(:each) do
    ENV.delete('PACT_BROKER_BASE_URL')
  end

end
