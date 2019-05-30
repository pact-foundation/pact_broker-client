require 'pact_broker/client/error'

 # BUILDKITE_BRANCH BUILDKITE_COMMIT https://buildkite.com/docs/pipelines/environment-variables
 # CIRCLE_BRANCH CIRCLE_SHA1 https://circleci.com/docs/2.0/env-vars/
 # TRAVIS_COMMIT TRAVIS_BRANCH - TRAVIS_PULL_REQUEST_BRANCH TRAVIS_PULL_REQUEST_SHA https://docs.travis-ci.com/user/environment-variables/
 # GIT_COMMIT GIT_BRANCH https://wiki.jenkins.io/display/JENKINS/Building+a+software+project
 # GIT_COMMIT GIT_LOCAL_BRANCH https://hudson.eclipse.org/webtools/env-vars.html/
 # APPVEYOR_REPO_COMMIT APPVEYOR_REPO_BRANCH       https://www.appveyor.com/docs/environment-variables/
 # bamboo.repository.git.branch https://confluence.atlassian.com/bamboo/bamboo-variables-289277087.html

module PactBroker
  module Client
    module Git
      COMMAND = 'git rev-parse --abbrev-ref HEAD'

      def self.branch
        `#{COMMAND}`.strip
      rescue StandardError => e
        raise PactBroker::Client::Error, "Could not determine current git branch using command `#{COMMAND}`. #{e.class} #{e.message}"
      end
    end
  end
end
