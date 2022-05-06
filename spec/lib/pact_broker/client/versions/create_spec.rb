require "pact_broker/client/versions/create"

module PactBroker
  module Client
    describe Versions::Create do
      describe "#call" do
        let(:index_body) do
          {
            "_links" => {
              "pb:pacticipant-branch-version" => {
                "href" => "http://broker/pacticipants/{pacticipant}/branches/{branch}/versions/{version}"
              },
              "pb:pacticipant-version-tag" => {
                "href" => "http://broker/pacticipants/{pacticipant}/versions/{version}/tags/{tag}"
              },
              "pb:pacticipant-version" => {
                "href" => "http://broker/pacticipants/{pacticipant}/versions/{version}"
              }
            }
          }
        end

        let!(:index_request) do
          stub_request(:get, "http://broker").to_return(status: 200, body: index_body.to_json, headers: { "Content-Type" => "application/hal+json" }  )
        end

        let!(:branch_request) do
          stub_request(:put, "http://broker/pacticipants/Foo/branches/main/versions/1").to_return(status: 200, body: "{}", headers: { "Content-Type" => "application/hal+json" }  )
        end

        let!(:tag_request) do
          stub_request(:put, "http://broker/pacticipants/Foo/versions/1/tags/dev").to_return(status: 200, body: "{}", headers: { "Content-Type" => "application/hal+json" }  )
        end

        let!(:create_version_request) do
          stub_request(:put, "http://broker/pacticipants/Foo/versions/1").to_return(status: 200, body: { version: "created" }.to_json, headers: { "Content-Type" => "application/hal+json" }  )
        end

        let!(:get_version_request) do
          stub_request(:get, "http://broker/pacticipants/Foo/versions/1").to_return(status: 200, body: { version: "got" }.to_json, headers: { "Content-Type" => "application/hal+json" }  )
        end

        let(:params) do
          {
            pacticipant_name: "Foo",
            version_number: "1",
            branch_name: branch_name,
            tags: tags
          }
        end

        let(:branch_name) { "main" }
        let(:tags) { ["dev"] }

        let(:options) do
          {
            verbose: "verbose",
            output: output
          }
        end

        let(:output) { "text" }

        let(:pact_broker_client_options) do
          {
            token: "token",
            pact_broker_base_url: "http://broker"
          }
        end

        subject { PactBroker::Client::Versions::Create.call(params, options, pact_broker_client_options)}

        context "with a branch and tags" do
          it "creates a branch version" do
            subject
            expect(branch_request).to have_been_made
          end

          it "creates the tag" do
            subject
            expect(tag_request).to have_been_made
          end

          it "returns a message" do
            expect(subject.message).to include "Created/updated pacticipant version 1 with branch main and tag(s) dev in the Pact Broker"
            expect(subject.success).to be true
          end

          context "without output json" do
            let(:output) { "json" }

            it "returns a json message" do
              expect(subject.message).to eq({ version: "got" }.to_json)
            end
          end
        end

        context "with only tags" do
          let(:branch_name) { nil }

          it "returns a message" do
            expect(subject.message).to include "Created/updated pacticipant version 1 with tag(s) dev in the Pact Broker"
            expect(subject.success).to be true
          end

          context "without output json" do
            let(:output) { "json" }

            it "returns a json message" do
              expect(subject.message).to eq({ version: "got" }.to_json)
            end
          end
        end

        context "with only a branch" do
          let(:tags) { nil }

          it "returns a message" do
            expect(subject.message).to include "Created/updated pacticipant version 1 with branch main in the Pact Broker"
            expect(subject.success).to be true
          end

          context "without output json" do
            let(:output) { "json" }

            it "returns a json message" do
              expect(subject.message).to eq({ version: "got" }.to_json)
            end
          end
        end

        context "with no branch or tags" do
          let(:tags) { nil }
          let(:branch_name) { nil }

          it "creates a version" do
            subject
            expect(create_version_request).to have_been_made
          end

          it "returns a message" do
            expect(subject.message).to include "Created/updated pacticipant version 1 in the Pact Broker"
            expect(subject.success).to be true
          end

          context "without output json" do
            let(:output) { "json" }

            it "returns a json message" do
              expect(subject.message).to eq({ version: "created" }.to_json)
            end
          end
        end

        context "when the Pact Broker does not support branch versions" do
          before do
            index_body["_links"].delete("pb:pacticipant-branch-version")
          end

          let(:index_body) do
            {
              "_links" => {}
            }
          end

          it "returns an error" do
            expect(subject.message).to include "does not support branch versions"
            expect(subject.success).to be false
          end
        end
      end
    end
  end
end
