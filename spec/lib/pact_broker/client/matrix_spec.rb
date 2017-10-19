require 'pact_broker/client/matrix'

module PactBroker
  module Client
    describe Matrix do
      context "when the matrix resource is not found because the broker is the wrong version" do
        let(:matrix) { Matrix.new(base_url: 'http://example.org') }
        let!(:request) { stub_request(:get, /matrix/).to_return(status: 404) }

        it "raises a helpful error" do
          expect { matrix.get([{name: "Foo", version: "1"}]) }.to raise_error PactBroker::Client::Error, %r{Matrix resource not found at http://example.org/matrix}
        end
      end
    end
  end
end
