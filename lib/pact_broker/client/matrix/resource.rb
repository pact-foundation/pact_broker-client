require 'pact_broker/client/base_client'

module PactBroker
  module Client
    class Matrix < BaseClient
      class Resource < Hash

        def initialize hash
          self.merge!(hash)
        end

        def any_unknown?
          if supports_unknown_count?
            unknown_count > 0
          else
            false
          end
        end

        def supports_unknown_count?
          !!(self[:summary] && Integer === self[:summary][:unknown] )
        end

        def unknown_count
          supports_unknown_count? ? self[:summary][:unknown] : nil
        end

        def reason
          self[:summary][:reason]
        end

        def deployable?
          self[:summary][:deployable]
        end
      end
    end
  end
end
