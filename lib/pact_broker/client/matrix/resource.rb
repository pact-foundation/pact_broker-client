require 'pact_broker/client/base_client'

module PactBroker
  module Client
    class Notice < Hash
      def initialize(hash)
        self.merge!(hash)
      end

      def text
        self[:text]
      end

      def type
        self[:type]
      end
    end
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

        def no_results?
          self[:summary][:success] == 0 && self[:summary][:failed] == 0
        end

        def supports_unknown_count?
          !!(self[:summary] && Integer === self[:summary][:unknown] )
        end

        def supports_ignore?
          !!(self[:summary] && Integer === self[:summary][:ignored] )
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

        def notices
          if self[:notices].is_a?(Array)
            self[:notices].collect { | notice_hash | Notice.new(notice_hash) }
          else
            nil
          end
        end
      end
    end
  end
end
