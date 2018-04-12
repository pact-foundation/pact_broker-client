require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

require "./spec/support/shared_context.rb"

is_windows = (RbConfig::CONFIG['host_os'] =~ /bccwin|cygwin|djgpp|mingw|mswin|wince/i) != nil

RSpec.configure do | config |

  config.before(:each) do
    ENV.delete('PACT_BROKER_BASE_URL')
  end

  config.filter_run_excluding :skip_windows => is_windows
end
