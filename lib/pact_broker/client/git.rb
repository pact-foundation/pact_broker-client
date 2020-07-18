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
BITBUCKET_BRANCH BITBUCKET_COMMIT https://confluence.atlassian.com/bitbucket/variables-in-pipelines-794502608.html

=end

# Keep in sync with pact-provider-verifier/lib/pact/provider_verifier/git.rb
module PactBroker
  module Client
    module Git
      COMMAND = 'git name-rev --name-only HEAD'.freeze
      BRANCH_ENV_VAR_NAMES = %w{BUILDKITE_BRANCH CIRCLE_BRANCH TRAVIS_BRANCH GIT_BRANCH GIT_LOCAL_BRANCH APPVEYOR_REPO_BRANCH CI_COMMIT_REF_NAME BITBUCKET_BRANCH}.freeze
      COMMIT_ENV_VAR_NAMES = %w{BUILDKITE_COMMIT CIRCLE_SHA1 TRAVIS_COMMIT GIT_COMMIT APPVEYOR_REPO_COMMIT CI_COMMIT_ID BITBUCKET_COMMIT}

      def self.commit
        find_commit_from_env_vars
      end

      def self.branch
        find_branch_from_env_vars || branch_from_git_command
      end

      # private

      def self.find_commit_from_env_vars
        COMMIT_ENV_VAR_NAMES.collect { |env_var_name| value_from_env_var(env_var_name) }.compact.first
      end

      def self.find_branch_from_env_vars
        BRANCH_ENV_VAR_NAMES.collect { |env_var_name| value_from_env_var(env_var_name) }.compact.first
      end

      def self.value_from_env_var(env_var_name)
        val = ENV[env_var_name]
        if val && val.strip.size > 0
          val
        else
          nil
        end
      end

      def self.branch_from_git_command
        branch_names = nil
        begin
          branch_names = execute_git_command
            .split("\n")
            .collect(&:strip)
            .reject(&:empty?)
            .collect(&:split)
            .collect(&:first)
            .collect{ |line| line.gsub(/^origin\//, '') }
            .reject{ |line| line == "HEAD" }

        rescue StandardError => e
          raise PactBroker::Client::Error, "Could not determine current git branch using command `#{COMMAND}`. #{e.class} #{e.message}"
        end

        validate_branch_names(branch_names)
        branch_names[0]
      end

      def self.validate_branch_names(branch_names)
        if branch_names.size == 0
          raise PactBroker::Client::Error, "Command `#{COMMAND}` didn't return anything that could be identified as the current branch."
        end

        if branch_names.size > 1
          raise PactBroker::Client::Error, "Command `#{COMMAND}` returned multiple branches: #{branch_names.join(", ")}. You will need to get the branch name another way."
        end
      end

      def self.execute_git_command
        `#{COMMAND}`
      end
    end
  end
end
