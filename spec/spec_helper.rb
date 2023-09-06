require 'webmock/rspec'
require 'rspec/its'

ENV["PACT_BROKER_CAN_I_DEPLOY_IGNORE"] = nil

WebMock.disable_net_connect!(allow_localhost: true)

require "./spec/support/shared_context.rb"
require "./spec/support/approvals.rb"

is_windows = (RbConfig::CONFIG['host_os'] =~ /bccwin|cygwin|djgpp|mingw|mswin|wince/i) != nil
is_ci = ENV['CI'] == 'true'

RSpec.configure do | config |

  config.before(:each) do
    ENV.delete('PACT_BROKER_BASE_URL')
    ENV.delete('PACT_BROKER_USERNAME')
    ENV.delete('PACT_BROKER_PASSWORD')
    ENV.delete('PACT_BROKER_TOKEN')
  end

  config.after(:all) do
    Pact::Fixture.check_fixtures
  end

  config.filter_run_excluding skip_windows: is_windows, skip_ci: is_ci
  config.example_status_persistence_file_path = "./spec/examples.txt"

  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    rescue SystemExit => e
      puts "CAUGHT SYSTEM EXIT"
      puts e
      puts e.backtrace
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end

module Pact
  module Fixture

    def self.add_fixture key, value
      fixtures[key] ||= []
      fixtures[key] << value
    end

    def self.fixtures
      @fixtures ||= {}
    end

    def self.check_fixtures
      fixtures.each do | fixture_group |
        if fixture_group.size > 1
          #TODO compare fixtures to ensure they match
        end
      end
    end
  end
end
