# frozen_string_literal: true

require 'pact_broker/client/version'

module PactBroker
  module Client
    class << self
      attr_accessor :tool_identifier

      def user_agent_string(http_lib_name, http_lib_version)
        base = "pact_broker-client/#{VERSION} #{http_lib_name}/#{http_lib_version} ruby/#{RUBY_VERSION}"
        if tool_identifier && !tool_identifier.empty?
          "#{tool_identifier} #{base}"
        else
          base
        end
      end
    end
  end
end
