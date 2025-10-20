require_relative '../../../pact_ruby_v2_spec_helper'
require 'pact_broker/client/can_i_deploy'

module PactBroker::Client
  describe Matrix, :pact => true do

  pact_broker
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"

    describe "can-i-deploy ignoring a pacticipant version" do
      let(:matrix_response_body) { matrix }
      let(:matrix) do
        {
          "summary" => {
            "deployable" => true,
            "ignored" => 1
          },
          "notices" => match_each("text" => "some notice", "type" => "info"),
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
                    "href" => match_type_of("http://result")
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
                    "href" => match_type_of("http://result")
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
        new_interaction
          .given("provider Bar version 4.5.6 has a successful verification for Foo version 1.2.3 tagged prod and a failed verification for version 3.4.5 tagged prod")
          .upon_receiving("a request to determine if Bar can be deployed with all Foo tagged prod, ignoring the verification for Foo version 3.4.5")
          .with_request(
            method: :get,
            path: "/matrix",
            # TIP: 
            # To setup a query parameter with 
            #  - multiple values for the same key
            # use an array of hashes otherwise you can pass a hash 
            query: 
            [ 
              {"q[][pacticipant]" => "Bar"}, # q[][pacticipant] => ["Bar"]
              {"q[][version]" => "4.5.6"},
              {"q[][pacticipant]" => "Foo"}, # now q[][pacticipant] => ["Bar", "Foo"]
              {"q[][tag]" => "prod"},
              {"latestby" => "cvpv"},
              {"ignore[][pacticipant]" => "Foo"},
              {"ignore[][version]" => "3.4.5"}
            ]
            # { # example of a query hash - duplicate keys will be overwritten
            #     "q[][pacticipant]" => "Bar", # q[][pacticipant] => ["Bar"]
            #     "q[][version]" => "4.5.6",
            #     "q[][pacticipant]" => "Foo", # q[][pacticipant] => ["Foo"]
            #     "q[][tag]" => "prod",
            #     "latestby" => "cvpv",
            #     "ignore[][pacticipant]" => "Foo",
            #     "ignore[][version]" => "3.4.5",          
            # }
          )
          .will_respond_with(
            status: 200,
            headers: pact_broker_response_headers,
            body: matrix_response_body
          )
      end

      let(:pact_broker_base_url) { "http://127.0.0.1:9999" }
      subject { PactBroker::Client::CanIDeploy.call(selectors, matrix_options, options, { pact_broker_base_url: pact_broker_base_url })}

      it 'returns the CLI output' do
        execute_http_pact do |mock_server|
          Approvals.verify(subject.message, :name => "can_i_deploy_ignore", format: :txt)
        end
      end
    end
  end
end
