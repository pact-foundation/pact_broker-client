require 'pact_broker/client/error'
require 'pact_broker/client/hash_refinements'

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
BUILD_SOURCEBRANCHNAME BUILD_SOURCEVERSION Azure
=end

# Keep in sync with pact-provider-verifier/lib/pact/provider_verifier/git.rb

# `git name-rev --name-only HEAD` provides "tags/v1.35.0^0"
module PactBroker
  module Client
    module Git
      using PactBroker::Client::HashRefinements

      COMMAND = 'git rev-parse --abbrev-ref HEAD'.freeze
      BRANCH_ENV_VAR_NAMES = %w{GITHUB_HEAD_REF GITHUB_REF BUILDKITE_BRANCH CIRCLE_BRANCH TRAVIS_BRANCH GIT_BRANCH GIT_LOCAL_BRANCH APPVEYOR_REPO_BRANCH CI_COMMIT_REF_NAME BITBUCKET_BRANCH BUILD_SOURCEBRANCHNAME}.freeze
      COMMIT_ENV_VAR_NAMES = %w{GITHUB_SHA BUILDKITE_COMMIT CIRCLE_SHA1 TRAVIS_COMMIT GIT_COMMIT APPVEYOR_REPO_COMMIT CI_COMMIT_ID BITBUCKET_COMMIT BUILD_SOURCEVERSION}
      BUILD_URL_ENV_VAR_NAMES = %w{BUILDKITE_BUILD_URL CIRCLE_BUILD_URL TRAVIS_BUILD_WEB_URL BUILD_URL }

      def self.commit
        find_commit_from_env_vars
      end

      def self.branch(options)
        find_branch_from_known_env_vars || find_branch_from_env_var_ending_with_branch || branch_from_git_command(options[:raise_error])
      end

      def self.build_url
        github_build_url || BUILD_URL_ENV_VAR_NAMES.collect{ | name | value_from_env_var(name) }.compact.first
      end

      # private

      def self.find_commit_from_env_vars
        COMMIT_ENV_VAR_NAMES.collect { |env_var_name| value_from_env_var(env_var_name) }.compact.first
      end

      def self.find_branch_from_known_env_vars
        val = BRANCH_ENV_VAR_NAMES.collect { |env_var_name| value_from_env_var(env_var_name) }.compact.first
        val.gsub(%r{^refs/heads/}, "") if val
      end

      def self.find_branch_from_env_var_ending_with_branch
        values = ENV.keys
          .select{ |env_var_name| env_var_name.end_with?("_BRANCH") }
          .collect{ |env_var_name| value_from_env_var(env_var_name) }.compact
        if values.size == 1
          values.first
        else
          nil
        end
      end

      def self.value_from_env_var(env_var_name)
        val = ENV[env_var_name]
        if val && val.strip.size > 0
          val
        else
          nil
        end
      end

      def self.branch_from_git_command(raise_error)
        branch_names = execute_and_parse_command(raise_error)
        validate_branch_names(branch_names) if raise_error
        branch_names.size == 1 ? branch_names[0] : nil
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

      def self.execute_and_parse_command(raise_error)
        execute_git_command
          .split("\n")
          .collect(&:strip)
          .reject(&:empty?)
          .collect(&:split)
          .collect(&:first)
          .collect{ |line| line.gsub(/^origin\//, '') }
          .reject{ |line| line == "HEAD" }
      rescue StandardError => e
        if raise_error
          raise PactBroker::Client::Error, "Could not determine current git branch using command `#{COMMAND}`. #{e.class} #{e.message}"
        else
          return []
        end
      end

      def self.github_build_url
        parts = %w{GITHUB_SERVER_URL GITHUB_REPOSITORY GITHUB_RUN_ID}.collect{ | name | value_from_env_var(name) }
        if parts.all?
          [parts[0], parts[1], "actions", "runs", parts[2]].join("/")
        end
      end
    end
  end
end
