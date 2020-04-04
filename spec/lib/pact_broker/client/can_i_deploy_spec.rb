require 'pact_broker/client/can_i_deploy'
require 'pact_broker/client/matrix/resource'

module PactBroker
  module Client
    describe CanIDeploy do
      let(:pact_broker_base_url) { 'http://example.org' }
      let(:version_selectors) { [{ pacticipant: "Foo", version: "1" }] }
      let(:matrix_options) { {} }
      let(:pact_broker_client_options) { { foo: 'bar' } }
      let(:matrix_client) { instance_double('PactBroker::Client::Matrix') }
      let(:matrix) { instance_double('Matrix::Resource', deployable?: true, reason: 'some reason', any_unknown?: any_unknown, supports_unknown_count?: supports_unknown_count) }
      let(:any_unknown) { false }
      let(:supports_unknown_count) { true }
      let(:retry_while_unknown) { 0 }
      let(:options) { { output: 'text', retry_while_unknown: retry_while_unknown, retry_interval: 5} }


      before do
        allow_any_instance_of(PactBroker::Client::PactBrokerClient).to receive(:matrix).and_return(matrix_client)
        allow(matrix_client).to receive(:get).and_return(matrix)
        allow(Matrix::Formatter).to receive(:call).and_return('text matrix')
      end

      subject { CanIDeploy.call(pact_broker_base_url, version_selectors, matrix_options, options, pact_broker_client_options) }

      it "retrieves the matrix from the pact broker" do
        expect(matrix_client).to receive(:get).with(version_selectors, matrix_options)
        subject
      end

      it "creates a text table out of the matrix" do
        expect(Matrix::Formatter).to receive(:call).with(matrix, 'text')
        subject
      end

      context "when the versions are deployable" do
        it "returns a success response" do
          expect(subject.success).to be true
        end

        it "returns a success message with the text table" do
          expect(subject.message).to include "Computer says yes"
          expect(subject.message).to include "\n\ntext matrix"
        end

        it "returns a success reason" do
          expect(subject.message).to include "some reason"
        end
      end

      context "when the versions are not deployable" do
        let(:matrix) { instance_double('Matrix::Resource', deployable?: false, reason: 'some reason', any_unknown?: false) }

        it "returns a failure response" do
          expect(subject.success).to be false
        end

        it "returns a failure message" do
          expect(subject.message).to include "Computer says no"
        end

        it "returns a failure reason" do
          expect(subject.message).to include "some reason"
        end
      end

      context "when retry_while_unknown is greater than 0" do
        let(:retry_while_unknown) { 1 }

        context "when any_unknown? is false" do
          it "does not retry the request" do
            expect(Retry).to_not receive(:until_truthy_or_max_times)
            subject
          end
        end

        context "when any_unknown? is true" do
          before do
            allow($stderr).to receive(:puts)
            allow(Retry).to receive(:until_truthy_or_max_times)
          end

          let(:any_unknown) { true }

          it "puts a message to stderr" do
            expect($stderr).to receive(:puts).with("Waiting for verification results to be published (up to 5 seconds)")
            subject
          end

          it "retries the request" do
            expect(Retry).to receive(:until_truthy_or_max_times).with(hash_including(times: 1, sleep: 5, sleep_first: true))
            subject
          end
        end

        context "when the matrix does not support the unknown count" do
          let(:supports_unknown_count) { false }

          it "returns a failure response" do
            expect(subject.success).to be false
          end

          it "returns a failure message" do
            expect(subject.message).to match /does not provide a count/
          end
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
          allow(Retry).to receive(:while_error) { |&block| block.call }
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
