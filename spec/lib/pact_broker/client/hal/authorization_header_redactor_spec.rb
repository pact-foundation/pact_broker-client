require 'pact_broker/client/hal/authorization_header_redactor'

module PactBroker
  module Client
    module Hal
      describe AuthorizationHeaderRedactor do
        let(:stream) { StringIO.new }
        let(:stream_redactor) { AuthorizationHeaderRedactor.new(stream) }

        it "redacts the authorizaton header" do
          stream_redactor << "\\r\\nAuthorization: Bearer TOKEN\\r\\n"
          expect(stream.string).to eq "\\r\\nAuthorization: [redacted]\\r\\n"
        end
      end
    end
  end
end
