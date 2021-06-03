require_relative 'pact_helper'
require 'pact_broker/client/can_i_deploy'

module PactBroker::Client
  describe Matrix, :pact => true do

    include_context "pact broker"

    describe "can-i-deploy ignoring a pacticipant version" do
      let(:matrix_response_body) { matrix }
      let(:matrix) do
        {
          "summary" => {
            "deployable" => true,
            "ignored" => 1
          },
          "notices" => Pact.each_like("text" => "some notice", "type" => "info"),
          "matrix" => [
            {
              "consumer" => {
                "name" => "Foo",
                "version" => {
                  "number" => "1.2.3"
                }
              },
              "provider" => {
                "name" => "Bar",
                "version" => {
                  "number" => "4.5.6"
                }
              },
              "verificationResult" => {
                "success" => true,
                "_links" => {
                  "self" => {
                    "href" => Pact.like("http://result")
                  }
                }
              }
            },{
              "consumer" => {
                "name" => "Foo",
                "version" => {
                  "number" => "3.4.5"
                }
              },
              "provider" => {
                "name" => "Bar",
                "version" => {
                  "number" => "4.5.6"
                }
              },
              "verificationResult" => {
                "success" => false,
                "_links" => {
                  "self" => {
                    "href" => Pact.like("http://result")
                  }
                }
              },
              "ignored" => true
            }
          ]
        }

      end
      let(:selectors) { [{ pacticipant: "Bar", version: "4.5.6" }, { pacticipant: "Foo", tag: "prod" } ] }
      let(:matrix_options) do
        {
          ignore_selectors: [{ pacticipant: "Foo", version: "3.4.5" }]
        }
      end
      let(:options) { { retry_while_unknown: 0, output: 'table' } }

      before do
        pact_broker
          .given("provider Bar version 4.5.6 has a successful verification for Foo version 1.2.3 tagged prod and a failed verification for version 3.4.5 tagged prod")
          .upon_receiving("a request to determine if Bar can be deployed with all Foo tagged prod, ignoring the verification for Foo version 3.4.5")
          .with(
            method: :get,
            path: "/matrix",
            query: "q%5B%5D%5Bpacticipant%5D=Bar&q%5B%5D%5Bversion%5D=4.5.6&q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Btag%5D=prod&latestby=cvpv&ignore%5B%5D%5Bpacticipant%5D=Foo&ignore%5B%5D%5Bversion%5D=3.4.5"
          )
          .will_respond_with(
            status: 200,
            headers: pact_broker_response_headers,
            body: matrix_response_body
          )
      end

      subject { PactBroker::Client::CanIDeploy.call(broker_base_url, selectors, matrix_options, options, {})}

      it 'returns the CLI output' do
        Approvals.verify(subject.message, :name => "can_i_deploy_ignore", format: :txt)
      end
    end
  end
end
