require 'pact_broker/client/deployments/record_undeployment'

module PactBroker
  module Client
    module Deployments
      describe RecordUndeployment do
        let(:params) do
          {
            pacticipant_name: "Foo",
            target: target,
            environment_name: "test"
          }
        end
        let(:target) { "customer-1" }
        let(:output) { "text" }
        let(:options) { { output: output, verbose: true } }
        let(:pact_broker_base_url) { "http://broker" }
        let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }

        let(:index_body_hash) do
          {
            _links: {
              :'pb:environments' => {
                href: environments_url
              },
              :'pb:pacticipant' => {
                href: pacticipant_url
              }
            }
          }
        end

        let(:environments_hash) do
          {
            _links: {
              :'pb:environments' => [
                {
                  name: "test",
                  href: test_environment_url
                }
              ]
            }
          }
        end

        let(:environment_hash) do
          {
            _links: {
              :'pb:currently-deployed-versions' => {
                href: currently_deployed_versions_url
              }
            }
          }
        end

        let(:deployed_versions_hash) do
          {
            _embedded: {
              deployedVersions: [
                {
                  target: "customer-1",
                  _links: {
                    self: {
                      href: deployed_version_url_1
                    }
                  }
                },
                {
                  target: returned_target_2,
                  _links: {
                    self: {
                      href: deployed_version_url_2
                    }
                  }
                }
              ]
            }
          }
        end

        let(:returned_target_2) { nil }
        let(:deployed_version_hash) do
          {
            _embedded: {
              version: {
                number: "2"
              }
            }
          }
        end

        let(:environments_url) { "#{webmock_base_url}/environments" }
        let(:test_environment_url) { "#{webmock_base_url}/environments/1234" }
        let(:currently_deployed_versions_url) { "#{webmock_base_url}/currently-deployed-versions" }
        let(:deployed_version_url_1) { "#{webmock_base_url}/deployed-version-1" }
        let(:deployed_version_url_2) { "#{webmock_base_url}/deployed-version-2" }
        let(:pacticipant_url) { "#{webmock_base_url}/pacticipant" }

        let(:webmock_base_url) { "http://broker" }

        let!(:index_request) do
          stub_request(:get, "http://broker").to_return(status: 200, body: index_body_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
        end

        let!(:environments_request) do
          stub_request(:get, "http://broker/environments").to_return(status: 200, body: environments_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
        end

        let!(:environment_request) do
          stub_request(:get, test_environment_url).to_return(status: 200, body: environment_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
        end

        let!(:deployed_versions_request) do
          stub_request(:get, currently_deployed_versions_url + "?pacticipant=Foo").to_return(status: 200, body: deployed_versions_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
        end

        let!(:deployed_version_patch_request_1) do
          stub_request(:patch, deployed_version_url_1).with(body: { currentlyDeployed: false}.to_json).to_return(status: 200, body: deployed_version_hash.to_json, headers: { "Content-Type" => "application/hal+json" })
        end

        let!(:deployed_version_patch_request_2) do
          stub_request(:patch, deployed_version_url_2).with(body: { currentlyDeployed: false}.to_json).to_return(status: 200, body: deployed_version_hash.to_json, headers: { "Content-Type" => "application/hal+json" })
        end

        let!(:pacticipant_request) do
          stub_request(:get, pacticipant_url).to_return(status: pacticipant_request_status, body: {}.to_json, headers: { "Content-Type" => "application/hal+json" })
        end

        let(:pacticipant_request_status) { 200 }

        subject { RecordUndeployment.call(params, options, pact_broker_client_options) }

        its(:success) { is_expected.to eq true }
        its(:message) { is_expected.to include "Recorded undeployment of Foo version 2 from test environment (target customer-1) in the Pact Broker" }

        context "when there is no pb:environments relation in the index" do
          let(:index_body_hash) do
            {
              _links: {}
            }
          end

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include "support" }
        end

        context "when output is json" do
          let(:output) { "json" }
          its(:message) { is_expected.to eq [deployed_version_hash].to_json }
        end

        context "when there is an error returned from one of the deployed version updates (there should only ever be one deployed version, but testing just for the sake of it)" do
          let!(:deployed_version_patch_request_2) do
            stub_request(:patch, deployed_version_url_2).to_return(status: 400, body: { errors: { foo: ["some error"]}}.to_json, headers: { "Content-Type" => "application/hal+json" })
          end

          let(:returned_target_2) { "customer-1" }

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include "Recorded undeployment of Foo version 2" }
          its(:message) { is_expected.to include "some error" }
        end

        context "when there is no currently-deployed-versions relation in the environment resource" do
          let(:environment_hash) do
            {
              _links: {}
            }
          end

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include "support" }
        end

        context "when a target is provided and there is no deployed version with a matching target" do
          let(:target) { "wrong" }
          let(:expected_message) { "Foo is not currently deployed to target 'wrong' in test environment. Please specify one of the following targets to record the undeployment from: customer-1, <no target>" }

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include expected_message }

          context "when output is json" do
            let(:output) { "json" }

            its(:message) { is_expected.to eq({ error: { message: expected_message } }.to_json) }
          end
        end

        context "when a target is not provided and there is no deployed verison without a target" do
          let(:target) { nil }
          let(:returned_target_2) { "customer-2" }

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include "Please specify one of the following targets to record the undeployment from: customer-1, customer-2" }
        end

        context "when there are no deployed versions for the pacticipant" do
          let(:deployed_versions_hash) do
            {
              _embedded: {
                deployedVersions: []
              }
            }
          end

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include "Foo is not currently deployed to test environment. Cannot record undeployment." }

          context "when the pacticipant does not exist" do
            let(:pacticipant_request_status) { 404 }

            its(:success) { is_expected.to be false }
            its(:message) { is_expected.to include "No pacticipant with name 'Foo' found" }
          end
        end
      end
    end
  end
end
