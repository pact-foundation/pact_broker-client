require 'pact_broker/client/git'

module PactBroker
  module Client
    module Git
      describe ".branch" do
        before do
          allow(ENV).to receive(:[]).and_call_original
          Git::BRANCH_ENV_VAR_NAMES.each do | env_var_name|
            allow(ENV).to receive(:[]).with(env_var_name).and_return(nil)
          end
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

        context "when there is no known environment variable for the branch", skip_ci: true do
          it "attempts to execute a git command to determine the value" do
            expect(subject).to_not be_empty
          end
        end

        context "when one git branch name is returned (apart from HEAD)" do
          before do
            allow(Git).to receive(:execute_git_command).and_return(" origin/HEAD \n origin/foo")
          end

          it "raises an error" do
            expect(subject).to eq "foo"
          end
        end

        context "when two git branch names are returned (apart from HEAD)" do
          before do
            allow(Git).to receive(:execute_git_command).and_return(" origin/HEAD \n origin/foo \n origin/bar")
          end

          it "raises an error" do
            expect { subject }.to raise_error PactBroker::Client::Error, /returned multiple branches: foo, bar/
          end
        end


        context "when the git branch name comes back as an empty string" do
          before do
            allow(Git).to receive(:execute_git_command).and_return(" origin/HEAD")
          end

          it "raises an error" do
            expect { subject }.to raise_error PactBroker::Client::Error, /didn't return anything/
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
