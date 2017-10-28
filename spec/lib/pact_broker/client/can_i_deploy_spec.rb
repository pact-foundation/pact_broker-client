require 'pact_broker/client/can_i_deploy'

module PactBroker
  module Client
    describe CanIDeploy do
      let(:pact_broker_base_url) { 'http://example.org' }
      let(:version_selectors) { [{pacticipant: "Foo", version: "1"}] }
      let(:pact_broker_client_options) { { foo: 'bar' } }
      let(:matrix_client) { instance_double('PactBroker::Client::Matrix') }
      let(:matrix) { {matrix: ['foo'], summary: {compatible: true}} }
      let(:options) { {output: 'text' } }

      before do
        allow_any_instance_of(PactBroker::Client::PactBrokerClient).to receive(:matrix).and_return(matrix_client)
        allow(matrix_client).to receive(:get).and_return(matrix)
        allow(Matrix::Formatter).to receive(:call).and_return('text matrix')
      end

      subject { CanIDeploy.call(pact_broker_base_url, version_selectors, options, pact_broker_client_options) }

      it "retrieves the matrix from the pact broker" do
        expect(matrix_client).to receive(:get).with(version_selectors)
        subject
      end

      it "creates a text table out of the matrix" do
        expect(Matrix::Formatter).to receive(:call).with(matrix, 'text')
        subject
      end

      context "when compatible versions are found" do
        it "returns a success response" do
          expect(subject.success).to be true
        end

        it "returns a success message with the text table" do
          expect(subject.message).to include "Computer says yes"
          expect(subject.message).to include "\n\ntext matrix"
        end
      end

      context "when compatible versions are not found" do
        let(:matrix) { {matrix: ['foo'], summary: {compatible: false}} }

        it "returns a failure response" do
          expect(subject.success).to be false
        end

        it "returns a failure message" do
          expect(subject.message).to include "Computer says no"
        end
      end

      context "when a PactBroker::Client::Error is raised" do
        before do
          allow(matrix_client).to receive(:get).and_raise(PactBroker::Client::Error.new('error text'))
        end

        it "returns a failure response" do
          expect(subject.success).to be false
        end

        it "returns a failure message" do
          expect(subject.message).to eq "error text"
        end
      end

      context "when a StandardError is raised" do
        before do
          allow(Retry).to receive(:sleep).and_return(0)
          allow($stderr).to receive(:puts)
          allow(matrix_client).to receive(:get).and_raise(StandardError.new('error text'))
        end

        it "returns a failure response" do
          expect(subject.success).to be false
        end

        it "returns a failure message and backtrace" do
          expect(subject.message).to include "Error retrieving matrix. StandardError - error text\n"
        end
      end
    end
  end
end
