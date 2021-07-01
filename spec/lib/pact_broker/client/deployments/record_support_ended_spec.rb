require 'pact_broker/client/deployments/record_support_ended'

module PactBroker
  module Client
    module Deployments
      describe RecordSupportEnded do
        let(:params) do
          {
            pacticipant_name: "Foo",
            version_number: version_number,
            environment_name: "test"
          }
        end
        let(:version_number) { "2" }
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
              :'pb:currently-supported-released-versions' => {
                href: currently_supported_versions_url
              }
            }
          }
        end

        let(:supported_versions_hash) do
          {
            _embedded: {
              releasedVersions: [
                {
                  number: "customer-1",
                  _links: {
                    self: {
                      href: supported_version_url_1
                    }
                  }
                },
                {
                  number: returned_target_2,
                  _links: {
                    self: {
                      href: supported_version_url_2
                    }
                  }
                }
              ]
            }
          }
        end

        let(:returned_target_2) { nil }
        let(:supported_version_hash) do
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
        let(:currently_supported_versions_url) { "#{webmock_base_url}/currently-deployed-versions" }
        let(:supported_version_url_1) { "#{webmock_base_url}/deployed-version-1" }
        let(:supported_version_url_2) { "#{webmock_base_url}/deployed-version-2" }
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

        let!(:supported_versions_request) do
          stub_request(:get, currently_supported_versions_url + "?pacticipant=Foo&version=2").to_return(status: 200, body: supported_versions_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
        end

        let!(:supported_version_patch_request_1) do
          stub_request(:patch, supported_version_url_1).with(body: { currentlySupported: false}.to_json).to_return(status: 200, body: supported_version_hash.to_json, headers: { "Content-Type" => "application/hal+json" })
        end

        let!(:supported_version_patch_request_2) do
          stub_request(:patch, supported_version_url_2).with(body: { currentlySupported: false}.to_json).to_return(status: 200, body: supported_version_hash.to_json, headers: { "Content-Type" => "application/hal+json" })
        end

        let!(:pacticipant_request) do
          stub_request(:get, pacticipant_url).to_return(status: pacticipant_request_status, body: {}.to_json, headers: { "Content-Type" => "application/hal+json" })
        end

        let(:pacticipant_request_status) { 200 }

        subject { RecordSupportEnded.call(params, options, pact_broker_client_options) }

        its(:success) { is_expected.to eq true }
        its(:message) { is_expected.to include "Recorded support ended for Foo version 2 in test environment in the Pact Broker" }

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
          its(:message) { is_expected.to eq [supported_version_hash, supported_version_hash].to_json }
        end

        context "when there is an error returned from one of the supported version updates (there should only ever be one supported version, but testing just for the sake of it)" do
          let!(:supported_version_patch_request_2) do
            stub_request(:patch, supported_version_url_2).to_return(status: 400, body: { errors: { foo: ["some error"]}}.to_json, headers: { "Content-Type" => "application/hal+json" })
          end

          let(:returned_target_2) { "customer-1" }

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include "Recorded" }
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

        context "when there is no matching supported versions" do
          let(:supported_versions_hash) do
            {
              _embedded: {
                releasedVersions: []
              }
            }
          end

          let(:expected_message) { "Foo version 2 is not currently released in test environment. Cannot record support ended." }

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include expected_message }

          context "when there are no supported versions for the pacticipant" do
            context "when the pacticipant does not exist" do
              let(:pacticipant_request_status) { 404 }

              its(:success) { is_expected.to be false }
              its(:message) { is_expected.to include "No pacticipant with name 'Foo' found" }
            end
          end

          context "when output is json" do
            let(:output) { "json" }

            its(:message) { is_expected.to eq({ error: { message: expected_message } }.to_json) }
          end
        end

      end
    end
  end
end
