require_relative 'pact_helper'
require 'pact_broker/client'

module PactBroker::Client
  describe Matrix, :pact => true do

    include_context "pact broker"

    describe "retriving the compatibility matrix" do
      let(:matrix_response_body) { { matrix: Pact.like(matrix) } }
      let(:matrix) { JSON.parse(File.read('spec/support/matrix.json')) }
      let(:selectors) { [{ name: "Foo", version: "1.2.3" }, { name: "Bar", version: "4.5.6" }] }

      context "when results are found" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6").
            upon_receiving("a request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6").
            with(
              method: :get,
              path: "/matrix",
              query: "pacticipant[]=Foo&version[]=1.2.3&pacticipant[]=Bar&version[]=4.5.6"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: matrix_response_body
            )
        end

        it 'a matrix of compatible versions' do
          matrix = pact_broker_client.matrix.get(selectors)
          expect(matrix.size).to eq 1
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
              query: "pacticipant[]=Foo+Thing&version[]=1.2.3&pacticipant[]=Bar&version[]=4.5.6"
            ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers,
              body: matrix_response_body
            )
        end

        let(:selectors) { [{ name: "Foo Thing", version: "1.2.3" }, { name: "Bar", version: "4.5.6" }] }

        it 'a matrix of compatible versions' do
          matrix = pact_broker_client.matrix.get(selectors)
          expect(matrix.size).to eq 1
        end
      end

      # context "with only one version selector" do
      #   before do
      #     pact_broker.
      #       given("the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6").
      #       upon_receiving("a request for the compatibility matrix where only the version of Foo is specified").
      #       with(
      #         method: :get,
      #         path: "/matrix",
      #         query: {
      #           'selectors[]' => ['Foo/version/1.2.3']
      #         }
      #       ).
      #       will_respond_with(
      #         status: 200,
      #         headers: pact_broker_response_headers,
      #         body: matrix_response_body
      #       )
      #   end
      # end

      context "when one or more of the versions does not exist" do
        before do
          pact_broker.
            given("the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6").
            upon_receiving("a request for the compatibility matrix where one or more versions does not exist").
            with(
              method: :get,
              path: "/matrix",
              query: "pacticipant[]=Foo&version[]=1.2.3&pacticipant[]=Bar&version[]=9.9.9"
            ).
            will_respond_with(
              status: 400,
              headers: pact_broker_response_headers,
              body: {
                errors: Pact.each_like("an error message")
              }
            )
        end

        let(:selectors) { [{ name: "Foo", version: "1.2.3" }, { name: "Bar", version: "9.9.9" }] }

        it 'returns a list of errors' do
          expect {
            pact_broker_client.matrix.get(selectors)
          }.to raise_error PactBroker::Client::Error, "an error message"
        end
      end

      context "when results are not found" do
        before do
          pact_broker.
            upon_receiving("a request for the compatibility matrix for a pacticipant that does not exist").
            with(
              method: :get,
              path: "/matrix",
              query: "pacticipant[]=Foo&version[]=1.2.3&pacticipant[]=Bar&version[]=9.9.9"
            ).
            will_respond_with(
              status: 400,
              headers: pact_broker_response_headers,
              body: {
                errors: Pact.each_like("an error message")
              }
            )
        end

        let(:selectors) { [{ name: "Foo", version: "1.2.3" }, { name: "Bar", version: "9.9.9" }] }

        it 'returns a list of errors' do
          expect {
            pact_broker_client.matrix.get(selectors)
          }.to raise_error PactBroker::Client::Error, "an error message"
        end
      end
    end
  end
end
