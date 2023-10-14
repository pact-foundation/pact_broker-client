require "open3"
require "pact_broker/client/cli/broker"

# This is not the ideal way to write a test, but I tried to write it with an in memory invocation,
# and I couldn't get the capture to work, and it became super complicated.

RSpec.describe "using unknown options", skip_windows: true do
  let(:unknown_switches_text) { "Unknown switches" }
  let(:warning_text) { "This is a warning"}
  let(:command) { "bundle exec bin/pact-broker can-i-deploy --pacticipant Foo --foo --broker-base-url http://example.org" }

  it "prints an 'unknown switches' warning to stderr and also includes the normal output of the command" do
    stderr_lines = nil

    Open3.popen3(command) do |stdin, stdout, stderr, thread|
       stderr_lines = stderr.readlines
    end

    expect(stderr_lines.join("\n")).to include(unknown_switches_text)
    expect(stderr_lines.join("\n")).to include(warning_text)

    expect(stderr_lines.size).to be > 2
  end


  context "with PACT_BROKER_ERROR_ON_UNKNOWN_OPTION=true" do
    it "prints an 'unknown switches' message to stderr and does NOT include the normal output of the command as it exits straight after" do
      stderr_lines = nil

      Open3.popen3({ "PACT_BROKER_ERROR_ON_UNKNOWN_OPTION" => "true" }, command) do |stdin, stdout, stderr, thread|
         stderr_lines = stderr.readlines
      end

      expect(stderr_lines.first).to include(unknown_switches_text)
      expect(stderr_lines.join("\n")).to_not include(warning_text)
      expect(stderr_lines.size).to eq 1
    end
  end
end
