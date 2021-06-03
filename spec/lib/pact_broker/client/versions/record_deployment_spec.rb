require 'pact_broker/client/versions/record_deployment'

module PactBroker
  module Client
    class Versions
      describe RecordDeployment do
        describe ".call" do
          let(:broker_base_url) { "http://broker" }
          let(:index_body_hash) do
            {
              _links: {}
            }
          end
          let!(:index_request) do
            stub_request(:get, broker_base_url).to_return(status: 200, body: index_body_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
          end

          let(:target) { "blue" }

          let(:params) do
            {
              pacticipant_name: "Foo",
              version_number: "1",
              environment_name: "test",
              target: target,
              output: "text"
            }
          end

          let(:pact_broker_client_options) { {} }

          subject { RecordDeployment.call(params, broker_base_url, pact_broker_client_options) }

          context "when the pb:environments relation does not exist" do
            it "returns an error response" do
              expect(subject.success).to be false
              expect(subject.message).to include "does not support"
            end
          end

          context "when the response headers contain Pactflow" do
            before do
              allow_any_instance_of(RecordDeployment).to receive(:check_if_command_supported)
              allow_any_instance_of(RecordDeployment).to receive(:check_environment_exists)
              allow_any_instance_of(RecordDeployment).to receive(:record_deployment)
              allow_any_instance_of(RecordDeployment).to receive(:deployed_version_resource).and_return(deployed_version_resource)
            end

            let(:response_headers) { { "X-Pactflow-Sha" => "abc" } }

            let(:deployed_version_resource) do
              double('PactBroker::Client::Hal::Entity', response: double('response', headers: response_headers) )
            end

            it "indicates the API was Pactflow" do
              expect(subject.message).to include "Recorded deployment of Foo version 1 to test environment (target blue) in Pactflow"
            end
          end

          context "when target is false" do
            before do
              allow_any_instance_of(RecordDeployment).to receive(:check_if_command_supported)
              allow_any_instance_of(RecordDeployment).to receive(:check_environment_exists)
              allow_any_instance_of(RecordDeployment).to receive(:record_deployment)
              allow_any_instance_of(RecordDeployment).to receive(:pact_broker_name).and_return("")
            end

            let(:target) { false }

            let(:deployed_version_resource) do
              double('PactBroker::Client::Hal::Entity', response: double('response', headers: response_headers) )
            end

            it "does not include the message about marking the previous version as undeployed" do
              expect(subject.message).to_not include "undeployed"
            end
          end
        end
      end
    end
  end
end
