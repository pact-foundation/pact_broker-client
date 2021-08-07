require "pact_broker/client/cli/broker"

RSpec.describe "the README" do
  NOT_DOCUMENTED = ["version"]
  COMMANDS = PactBroker::Client::CLI::Broker
              .commands
              .values
              .collect(&:usage).collect { | usage | usage.split(" ").first } - NOT_DOCUMENTED
  README = File.read("README.md")

  COMMANDS.each do | command |
    it "includes the documentation for #{command}" do
      expect(README.include?("\n#### " + command)).to be_truthy
    end
  end
end
