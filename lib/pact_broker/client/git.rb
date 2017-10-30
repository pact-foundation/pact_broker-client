require 'pact_broker/client/error'

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
