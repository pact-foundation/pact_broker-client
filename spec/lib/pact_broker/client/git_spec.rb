require 'pact_broker/client/git'

module PactBroker
  module Client
    module Git
      describe ".branch" do
        before do
          allow(ENV).to receive(:[]).and_call_original
        end

        subject { Git.branch }

        context "when there is a known environment variable for the branch" do
          before do
            allow(ENV).to receive(:[]).with("BUILDKITE_BRANCH").and_return("")
            allow(ENV).to receive(:[]).with("TRAVIS_BRANCH").and_return("foo")
          end

          it "returns the value of the environment variable" do
            expect(subject).to eq "foo"
          end
        end

        context "when there is no known environment variable for the branch" do
          it "attempts to execute a git command to determine the value" do
            expect { subject }.to_not raise_error
          end
        end

        context "when the git branch name comes back as HEAD" do
          before do
            allow(Git).to receive(:execute_git_command).and_return("HEAD")
          end

          it "raises an error" do
            expect { subject }.to raise_error PactBroker::Client::Error, /returned 'HEAD'/
          end
        end

        context "when the git branch name comes back as an empty string" do
          before do
            allow(Git).to receive(:execute_git_command).and_return("")
          end

          it "raises an error" do
            expect { subject }.to raise_error PactBroker::Client::Error, /an empty string/
          end
        end

        context "when there is an error executing the git command" do
          before do
            allow(Git).to receive(:execute_git_command).and_raise("some error")
          end

          it "raises an error" do
            expect { subject }.to raise_error PactBroker::Client::Error, /some error/
          end
        end
      end
    end
  end
end
