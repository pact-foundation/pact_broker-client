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
          allow(Git).to receive(:execute_git_command).and_return(" origin/HEAD \n origin/foo")
        end

        let(:raise_exception) { true }

        subject { Git.branch(raise_error: raise_exception) }

        shared_examples_for "when raise_error is false" do
          context "when raise_error is false" do
            let(:raise_exception) { false }

            it { is_expected.to be nil }
          end
        end

        context "when there is a known environment variable for the branch" do
          before do
            allow(ENV).to receive(:[]).with("BUILDKITE_BRANCH").and_return("")
            allow(ENV).to receive(:[]).with("TRAVIS_BRANCH").and_return("foo")
          end

          it "returns the value of the environment variable" do
            expect(subject).to eq "foo"
          end
        end

        context "when the branch starts with refs/heads/" do
          before do
            allow(ENV).to receive(:[]).with("GITHUB_REF").and_return("refs/heads/feature-x")
          end

          it "trims off the refs/heads/" do
            expect(subject).to eq "feature-x"
          end
        end

        context "when there is one environment variable ending with _BRANCH" do
          before do
            allow(ENV).to receive(:keys).and_return(%w{FOO_BRANCH BAR_BRANCH BLAH})
            allow(ENV).to receive(:[]).with("FOO_BRANCH").and_return("")
            allow(ENV).to receive(:[]).with("BAR_BRANCH").and_return("meep")
          end

          it "returns the value of that environment variable" do
            expect(subject).to eq "meep"
          end
        end

        context "when there is more than one environment variable ending with _BRANCH" do
          it "attempts to execute a git command to determine the value" do
            expect(Git).to receive(:execute_git_command)
            expect(subject).to_not be_empty
          end
        end

        context "when there is no known environment variable for the branch", skip_ci: true do
          it "attempts to execute a git command to determine the value" do
            expect(Git).to receive(:execute_git_command)
            expect(subject).to_not be_empty
          end
        end

        context "when one git branch name is returned (apart from HEAD)" do
          before do
            allow(Git).to receive(:execute_git_command).and_return(" origin/HEAD \n origin/foo")
          end

          it "returns the branch" do
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

          include_examples "when raise_error is false"
        end


        context "when the git branch name comes back as an empty string" do
          before do
            allow(Git).to receive(:execute_git_command).and_return(" origin/HEAD")
          end

          it "raises an error" do
            expect { subject }.to raise_error PactBroker::Client::Error, /didn't return anything/
          end

          include_examples "when raise_error is false"
        end

        context "when there is an error executing the git command" do
          before do
            allow(Git).to receive(:execute_git_command).and_raise("some error")
          end

          it "raises an error" do
            expect { subject }.to raise_error PactBroker::Client::Error, /some error/
          end

          include_examples "when raise_error is false"
        end
      end

      describe ".build_url" do
        before do
          allow(ENV).to receive(:[]).and_call_original
        end

        subject { Git.build_url }

        context "when nothing is set" do
          before do
            allow(ENV).to receive(:[]).and_return(nil)
          end

          it { is_expected.to eq nil }
        end

        context "when BUILDKITE_BUILD_URL is set" do
          before do
            allow(ENV).to receive(:[]).with("BUILDKITE_BUILD_URL").and_return("http://build")
          end

          it { is_expected.to eq "http://build" }
        end

        context "when the Github Actions env vars are set" do
          before do
            allow(ENV).to receive(:[]).with("GITHUB_SERVER_URL").and_return("https://github.com")
            allow(ENV).to receive(:[]).with("GITHUB_REPOSITORY").and_return("org/repo")
            allow(ENV).to receive(:[]).with("GITHUB_RUN_ID").and_return("1")
          end

          it { is_expected.to eq "https://github.com/org/repo/actions/runs/1" }
        end
      end
    end
  end
end
