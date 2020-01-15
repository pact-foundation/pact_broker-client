require 'pact_broker/client/error'

=begin

BUILDKITE_BRANCH BUILDKITE_COMMIT https://buildkite.com/docs/pipelines/environment-variables
CIRCLE_BRANCH CIRCLE_SHA1 https://circleci.com/docs/2.0/env-vars/
TRAVIS_COMMIT TRAVIS_BRANCH - TRAVIS_PULL_REQUEST_BRANCH TRAVIS_PULL_REQUEST_SHA https://docs.travis-ci.com/user/environment-variables/
GIT_COMMIT GIT_BRANCH https://wiki.jenkins.io/display/JENKINS/Building+a+software+project
GIT_COMMIT GIT_LOCAL_BRANCH https://hudson.eclipse.org/webtools/env-vars.html/
APPVEYOR_REPO_COMMIT APPVEYOR_REPO_BRANCH       https://www.appveyor.com/docs/environment-variables/
CI_COMMIT_REF_NAME https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
CI_BRANCH CI_COMMIT_ID https://documentation.codeship.com/pro/builds-and-configuration/environment-variables/
bamboo.repository.git.branch https://confluence.atlassian.com/bamboo/bamboo-variables-289277087.html

=end

# Keep in sync with pact-provider-verifier/lib/pact/provider_verifier/git.rb
module PactBroker
  module Client
    module Git
      COMMAND = 'git name-rev --name-only HEAD'.freeze
      BRANCH_ENV_VAR_NAMES = %w{BUILDKITE_BRANCH CIRCLE_BRANCH TRAVIS_BRANCH GIT_BRANCH GIT_LOCAL_BRANCH APPVEYOR_REPO_BRANCH CI_COMMIT_REF_NAME}.freeze

      def self.branch
        find_branch_from_env_vars || branch_from_git_command
      end

      # private

      def self.find_branch_from_env_vars
        BRANCH_ENV_VAR_NAMES.collect { |env_var_name| branch_from_env_var(env_var_name) }.compact.first
      end

      def self.branch_from_env_var(env_var_name)
        val = ENV[env_var_name]
        if val && val.strip.size > 0
          val
        else
          nil
        end
      end

      def self.branch_from_git_command
        branch_name = nil
        begin
          branch_name = execute_git_command.strip
        rescue StandardError => e
          raise PactBroker::Client::Error, "Could not determine current git branch using command `#{COMMAND}`. #{e.class} #{e.message}"
        end

        validate_branch_name(branch_name)
        branch_name
      end

      def self.validate_branch_name(branch_name)
        if !branch_name || branch_name.size == 0
          raise PactBroker::Client::Error, "Command `#{COMMAND}` returned an empty string when trying to determine the git branch name. This is most likely not the value you want. You will need to get the branch name another way."
        end

        if branch_name == "HEAD"
          raise PactBroker::Client::Error, "Command `#{COMMAND}` returned 'HEAD' when trying to determine the git branch name. This is probably because the repository is in detatched HEAD state. HEAD is most likely not the value you want. You will need to get the branch name another way."
        end
      end

      def self.execute_git_command
        `#{COMMAND}`
      end
    end
  end
end
