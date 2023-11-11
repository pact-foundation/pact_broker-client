require "pact_broker/client/branches/delete_branch"

module PactBroker
  module Client
    module Branches
      describe DeleteBranch do
        before do
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:sleep)
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:default_max_tries).and_return(1)
        end

        let(:params) do
          {
            pacticipant: "Foo",
            branch: "main",
            error_when_not_found: error_when_not_found
          }
        end
        let(:options) do
          {
            verbose: verbose
          }
        end
        let(:error_when_not_found) { true }
        let(:pact_broker_base_url) { "http://example.org" }
        let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }
        let(:response_headers) { { "Content-Type" => "application/hal+json"} }
        let(:verbose) { false }

        before do
          stub_request(:get, "http://example.org/").to_return(status: 200, body: index_response_body, headers: response_headers)
          stub_request(:delete, "http://example.org/pacticipants/Foo/branches/main").to_return(status: delete_response_status, body: delete_response_body, headers: response_headers)
        end
        let(:delete_response_status) { 200 }

        let(:index_response_body) do
          {
            "_links" => {
              "pb:pacticipant-branch" => {
                "href" => "http://example.org/pacticipants/{pacticipant}/branches/{branch}"
              }
            }
          }.to_json
        end

        let(:delete_response_body) do
          { "some" => "error message" }.to_json
        end

        subject { DeleteBranch.call(params, options, pact_broker_client_options) }

        context "when the branch is deleted" do
          it "returns a success result" do
            expect(subject.success).to be true
            expect(subject.message).to include "Successfully deleted branch main of pacticipant Foo"
          end
        end

        context "when there is a non-404 error" do
          let(:delete_response_status) { 403 }

          it "returns an error result with the response body" do
            expect(subject.success).to be false
            expect(subject.message).to include "error message"
          end
        end

        context "when the branch is not found" do
          let(:delete_response_status) { 404 }

          context "when error_when_not_found is true" do
            it "returns an error" do
              expect(subject.success).to be false
              expect(subject.message).to include "Could not delete branch main of pacticipant Foo as it was not found"
            end
          end

          context "when error_when_not_found is false" do
            let(:error_when_not_found) { false }

            it "return a success" do
              expect(subject.success).to be true
              expect(subject.message).to include "Branch main of pacticipant Foo not found"
            end
          end
        end

        context "when deleting branches is not supported" do
          let(:index_response_body) do
            {
              _links: {}
            }.to_json
          end

          it "returns an error" do
            expect(subject.success).to be false
            expect(subject.message).to include "not support"
          end
        end
      end
    end
  end
end
