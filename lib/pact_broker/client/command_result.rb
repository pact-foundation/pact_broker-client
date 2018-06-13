module PactBroker
  module Client
    class CommandResult
      attr_reader :success, :message

      def initialize success, message = nil
        @success = success
        @message = message
      end
    end
  end
end