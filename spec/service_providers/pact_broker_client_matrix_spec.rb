require_relative 'pact_helper'
require 'pact_broker/client'

module PactBroker::Client
  describe Matrix, :pact => true do

    include_context "pact broker"

    describe "retriving the compatibility matrix" do
      let(:matrix_response_body) { Pact.like(matrix) }
      let(:matrix) { JSON.parse(File.read('spec/support/matrix.json')) }
      let(:selectors) { [{ pacticipant: "Foo", version: "1.2.3" }, { pacticipant: "Bar", version: "4.5.6" }] }

      context "when results are found" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6").
            upon_receiving("a request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Foo&q[][version]=1.2.3&q[][pacticipant]=Bar&q[][version]=4.5.6&latestby=cvpv"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: matrix_response_body
            )
        end

        it 'returns the pact matrix' do
          matrix = pact_broker_client.matrix.get(selectors)
          expect(matrix[:matrix].size).to eq 1
        end
      end

      context "when the pacticipant name has a space in it" do
        before do
          pact_broker.
            given("the pact for Foo Thing version 1.2.3 has been verified by Bar version 4.5.6").
            upon_receiving("a request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Foo%20Thing&q[][version]=1.2.3&q[][pacticipant]=Bar&q[][version]=4.5.6&latestby=cvpv"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: matrix_response_body
            )
        end

        let(:selectors) { [{ pacticipant: "Foo Thing", version: "1.2.3" }, { pacticipant: "Bar", version: "4.5.6" }] }

        it 'incorrectly escapes the spaces but it still seems to work' do
          matrix = pact_broker_client.matrix.get(selectors)
          expect(matrix[:matrix].size).to eq 1
        end
      end

      context "with only one version selector" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6 and version 5.6.7").
            upon_receiving("a request for the compatibility matrix where only the version of Foo is specified").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Foo&q[][version]=1.2.3&latestby=cvp"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: matrix_response_body
            )
        end

        let(:selectors) { [{ pacticipant: "Foo", version: "1.2.3" }] }

        it 'returns the row with the lastest verification for version 1.2.3' do
          matrix = pact_broker_client.matrix.get(selectors)
          expect(matrix[:matrix].size).to eq 1
        end
      end

      context "when one or more of the versions does not exist" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6").
            upon_receiving("a request for the compatibility matrix where one or more versions does not exist").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Foo&q[][version]=1.2.3&q[][pacticipant]=Bar&q[][version]=9.9.9&latestby=cvpv"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: {
                summary: {
                  reason: Pact.like("an error message")
                }
              }
            )
        end

        let(:selectors) { [{ pacticipant: "Foo", version: "1.2.3" }, { pacticipant: "Bar", version: "9.9.9" }] }

        it 'does not raise an error' do
          pact_broker_client.matrix.get(selectors)
        end
      end

      context "when results are not found" do
        before do
          pact_broker.
            upon_receiving("a request for the compatibility matrix for a pacticipant that does not exist").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Wiffle&q[][version]=1.2.3&q[][pacticipant]=Meep&q[][version]=9.9.9&latestby=cvpv"
            ).
            will_respond_with(
              status: 400,
              headers: pact_broker_response_headers,
              body: {
                errors: Pact.each_like("an error message")
              }
            )
        end

        let(:selectors) { [{ pacticipant: "Wiffle", version: "1.2.3" }, { pacticipant: "Meep", version: "9.9.9" }] }

        it 'raises an error' do
          expect {
            pact_broker_client.matrix.get(selectors)
          }.to raise_error PactBroker::Client::Error, "an error message"
        end
      end

      context "when no versions are specified" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 and 1.2.4 has been verified by Bar version 4.5.6").
            upon_receiving("a request for the compatibility matrix for all versions of Foo and Bar").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Foo&q[][pacticipant]=Bar&latestby=cvpv"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: {
                matrix: Pact.each_like(matrix_row, min: 2)
              }
            )
        end
        let(:matrix_row) { JSON.parse(File.read('spec/support/matrix.json'))['matrix'].first }
        let(:selectors) { [{ pacticipant: "Foo" }, { pacticipant: "Bar" }] }

        it "returns multiple rows" do
          matrix = pact_broker_client.matrix.get(selectors)
          expect(matrix[:matrix].size).to eq 2
        end
      end

      context "when the success option is true" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9").
            upon_receiving("a request for the successful rows of the compatibility matrix for all versions of Foo and Bar").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Foo&q[][pacticipant]=Bar&latestby=cvpv&success[]=true"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: matrix_response_body
            )
        end
        let(:matrix_row) { JSON.parse(File.read('spec/support/matrix.json'))['matrix'].first }
        let(:selectors) { [{ pacticipant: "Foo" }, { pacticipant: "Bar" }] }
        let(:options) { {success: true} }

        it "returns only the successful row" do
          matrix = pact_broker_client.matrix.get(selectors, options)
          expect(matrix[:matrix].size).to eq 1
        end
      end

      context "when the latest version for a given tag is specified" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 with tag prod, and 1.2.4 unsuccessfully by 9.9.9").
            upon_receiving("a request for the compatibility matrix for Foo version 1.2.3 and the latest prod version of Bar").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Foo&q[][version]=1.2.3&q[][pacticipant]=Bar&q[][latest]=true&q[][tag]=prod&latestby=cvpv"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: matrix_response_body
            )
        end
        let(:matrix_row) { JSON.parse(File.read('spec/support/matrix.json'))['matrix'].first }
        let(:selectors) { [{ pacticipant: "Foo", version: "1.2.3"}, { pacticipant: "Bar", latest: true, tag: 'prod' }] }
        let(:options) { {} }

        it "returns the matrix with the latest prod version of Bar" do
          matrix = pact_broker_client.matrix.get(selectors, options)
          expect(matrix[:matrix].size).to eq 1
        end
      end

      context "when the latest version is specified" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9").
            upon_receiving("a request for the compatibility matrix for Foo version 1.2.3 and the latest version of Bar").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Foo&q[][version]=1.2.4&q[][pacticipant]=Bar&q[][latest]=true&latestby=cvpv"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: matrix_response_body
            )
        end
        let(:matrix_row) { JSON.parse(File.read('spec/support/matrix.json'))['matrix'].first }
        let(:selectors) { [{ pacticipant: "Foo", version: "1.2.4"}, { pacticipant: "Bar", latest: true }] }
        let(:options) { {} }

        it "returns the matrix with the latest prod version of Bar" do
          matrix = pact_broker_client.matrix.get(selectors, options)
          expect(matrix[:matrix].size).to eq 1
        end
      end

      context "when checking if we can deploy with the latest tagged versions of the other services" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 (tagged prod) and version 5.6.7").
            upon_receiving("a request for the compatibility matrix for Foo version 1.2.3 and the latest prod versions of all other pacticipants").
            with(
              method: :get,
              path: "/matrix",
              query: "q[][pacticipant]=Foo&q[][version]=1.2.3&latestby=cvp&latest=true&tag=prod"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: matrix_response_body
            )
        end

        let(:selectors) { [{ pacticipant: "Foo", version: "1.2.3" }] }

        let(:matrix_response_body) {
          {
            matrix: [{
              consumer: { name: 'Foo', version: { number: '1.2.3' } },
              provider: { name: 'Bar', version: { number: '4.5.6'} },
            }]
          }
        }

        let(:options) { { to_tag: 'prod' } }

        it "returns the matrix with the latest prod version of Bar" do
          matrix = pact_broker_client.matrix.get(selectors, options)
          expect(matrix[:matrix].size).to eq 1
        end
      end
    end
  end
end
