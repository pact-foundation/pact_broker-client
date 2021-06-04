require 'pact_broker/client/deployments/record_deployment'

module PactBroker
  module Client
    module Deployments
      describe RecordDeployment do
        describe ".call" do
          let(:broker_base_url) { "http://broker" }
          let(:index_body_hash) do
            {
              _links: {
                "pb:environments" => { href: "#{broker_base_url}/environments" },
                "pb:pacticipant-version" => {
                  href: "#{broker_base_url}/pacticipants/{pacticipant}/versions/{version}"
                }
              }
            }
          end
          let(:version_body_hash) do
            {
              "_links" => {
                "pb:record-deployment" => [
                  {
                    name: "test",
                    href: "#{broker_base_url}/record-deployment"
                  }
                ]
              }
            }
          end
          let(:environments_body_hash) do
            {
              "_links" => {
                "pb:environments" => [
                  {
                    "name" => "test",
                    "href" => ""
                  }
                ]
              }

            }
          end
          let(:record_deployment_body_hash) do
            { "some" => "response" }
          end
          let!(:index_request) do
            stub_request(:get, broker_base_url).to_return(status: 200, body: index_body_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
          end
          let!(:version_request) do
            stub_request(:get, broker_base_url + "/pacticipants/Foo/versions/1").to_return(status: 200, body: version_body_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
          end

          let!(:environments_request) do
            stub_request(:get, "http://broker/environments").
              with(headers: { 'Accept'=>'application/hal+json' }).
              to_return(status: 200, body: environments_body_hash.to_json, headers: { "Content-Type" => "application/hal+json" })
          end
          let!(:record_deployment_request) do
            stub_request(:post, "http://broker/record-deployment").
              to_return(status: 200, body: record_deployment_body_hash.to_json , headers: {})
          end

          let(:target) { "blue" }

          let(:params) do
            {
              pacticipant_name: "Foo",
              version_number: "1",
              environment_name: "test",
              target: target
            }
          end

          let(:options) do
            {
              output: output,
              verbose: true
            }
          end
          let(:output) { "text" }
          let(:pact_broker_client_options) { { pact_broker_base_url: broker_base_url} }

          subject { RecordDeployment.call(params, options, pact_broker_client_options) }

          context "when the pb:environments relation does not exist" do
            let(:index_body_hash) do
              {
                "_links" => {}
              }
            end
            it "returns an error response" do
              expect(subject.success).to be false
              expect(subject.message).to include "does not support"
            end
          end

          context "when the specified version does not exist" do
            let!(:version_request) do
              stub_request(:get, broker_base_url + "/pacticipants/Foo/versions/1").to_return(status: 404)
            end

            it "returns an error response" do
              expect(subject.success).to be false
              expect(subject.message).to include "Foo version 1 not found"
            end
          end

          context "when the pacticipant version does not support recording deployments" do
            let(:version_body_hash) do
              {
                "_links" => {}
              }
            end
            it "returns an error response" do
              expect(subject.success).to be false
              expect(subject.message).to include "does not support"
            end
          end

          context "when the specified environment is not available for recording a deployment" do
            let(:version_body_hash) do
              {
                "_links" => {
                  "pb:record-deployment" => [
                    {
                      "name" => "prod",
                      "href" => ""
                    }
                  ]
                }
              }
            end

            context "when the environment does not exist" do
              let(:environments_body_hash) do
                {
                  "_links" => {
                    "pb:environments" => [
                      {
                        "name" => "prod",
                        "href" => ""
                      },{
                        "name" => "uat",
                        "href" => ""
                      }
                    ]
                  }
                }
              end

              it "returns an error response" do
                expect(subject.success).to be false
                expect(subject.message).to include "No environment found with name 'test'. Available options: prod"
              end
            end

            context "when the environment does exist" do
              it "returns an error response" do
                expect(subject.success).to be false
                expect(subject.message).to include "Environment 'test' is not an available option for recording a deployment of Foo. Available options: prod"
              end
            end
          end

          context "when the output is json" do
            let(:output) { "json" }

            it "returns the JSON payload" do
              expect(JSON.parse(subject.message)).to eq record_deployment_body_hash
            end
          end

          context "when the response headers contain Pactflow" do
            before do
              allow_any_instance_of(RecordDeployment).to receive(:check_if_command_supported)
              allow_any_instance_of(RecordDeployment).to receive(:check_environment_exists)
              allow_any_instance_of(RecordDeployment).to receive(:record_action)
              allow_any_instance_of(RecordDeployment).to receive(:index_resource).and_return(index_resource)
            end

            let(:response_headers) { { "X-Pactflow-Sha" => "abc" } }

            let(:index_resource) do
              double('PactBroker::Client::Hal::Entity', response: double('response', headers: response_headers) )
            end

            it "indicates the API was Pactflow" do
              expect(subject.message).to include "Recorded deployment of Foo version 1 to test environment (target blue) in Pactflow"
            end

            context "when target is nil" do
              let(:target) { nil }

              it "does not include the target in the result message" do
                expect(subject.message).to include "Recorded deployment of Foo version 1 to test environment in"
              end
            end
          end
        end
      end
    end
  end
end
