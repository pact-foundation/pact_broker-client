module PactBroker::Client
  describe PactBrokerClient, :pact => true do

    include_context "pact broker"

    describe "publishing a pact" do

      let(:options) { { pact_json: pact_json, consumer_version: consumer_version }}
      let(:location) { 'http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/latest' }
      context "when the provider already exists in the pact-broker" do

        before do
          pact_broker.
          given("the 'Pricing Service' already exists in the pact-broker").
          upon_receiving("a request to publish a pact").
          with(
            method: :put,
            path: '/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
            headers: default_request_headers,
            body: pact_hash ).
          will_respond_with(
            headers: pact_broker_response_headers,
            status: 201,
            body: {
              _links: {
                :'pb:latest-pact-version' => {
                  href: location
                }
              }
            }
          )
        end
        it "returns the URL to find the newly published pact" do
          expect(pact_broker_client.pacticipants.versions.pacts.publish(options)).to eq location
        end
      end

      context "when the provider, consumer, pact and version already exist in the pact-broker" do
        before do
          pact_broker.
            given("the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0").
            upon_receiving("a request to publish a pact").
            with(
              method: :put,
              path: '/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: default_request_headers,
              body: pact_hash ).
            will_respond_with(
              headers: pact_broker_response_headers,
              status: 200,
              body: {
                _links: {
                  :'pb:latest-pact-version' => {
                    href: location
                  }
                }
              }
            )
        end
        it "returns true" do
            expect(pact_broker_client.pacticipants.versions.pacts.publish(options)).to be_truthy
        end
      end

      context "when the provider does not exist, but the consumer, pact and version already exist in the pact-broker" do
        before do
          pact_broker.
            given("'Condor' already exist in the pact-broker, but the 'Pricing Service' does not").
            upon_receiving("a request to publish a pact").
            with(
              method: :put,
              path: '/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: default_request_headers,
              body: pact_hash ).
            will_respond_with(
              headers: pact_broker_response_headers,
              status: 201,
              body: {
                _links: {
                  :'pb:latest-pact-version' => {
                    href: location
                  }
                }
              }
            )
        end
        it "returns true" do
            expect(pact_broker_client.pacticipants.versions.pacts.publish(options)).to be_truthy
        end
      end

      context "when publishing is not successful" do
        before do
          pact_broker.
            given("an error occurs while publishing a pact").
            upon_receiving("a request to publish a pact").
            with(
              method: :put,
              path: '/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: default_request_headers,
              body: pact_hash ).
            will_respond_with(
              status: 500,
              headers: {'Content-Type' => 'application/json'},
              body: {
                message: Pact::Term.new(matcher: /.*/, generate: 'An error occurred')
              }
            )
        end
        it "raises an error" do
          expect { pact_broker_client.pacticipants.versions.pacts.publish options }.to raise_error /An error occurred/
        end
      end

    end
  end
end