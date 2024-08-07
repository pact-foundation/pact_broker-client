require 'pact_broker/client/can_i_deploy'
require 'pact_broker/client/matrix/resource'

module PactBroker
  module Client
    describe CanIDeploy do
      let(:pact_broker_base_url) { 'http://example.org' }
      let(:version_selectors) { [{ pacticipant: "Foo", version: "1" }] }
      let(:matrix_options) { { } }
      let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url, foo: 'bar' } }
      let(:dry_run) { false }
      let(:matrix_client) { instance_double('PactBroker::Client::Matrix') }
      let(:matrix) do
        instance_double('Matrix::Resource',
          deployable?: deployable,
          reason: 'some reason',
          any_unknown?: any_unknown,
          supports_unknown_count?: supports_unknown_count,
          supports_ignore?: supports_ignore,
          unknown_count: unknown_count,
          notices: notices)
      end
      let(:unknown_count) { 0 }
      let(:any_unknown) { unknown_count > 0 }
      let(:supports_unknown_count) { true }
      let(:retry_while_unknown) { 0 }
      let(:options) { { output: 'text', retry_while_unknown: retry_while_unknown, retry_interval: 5, dry_run: dry_run } }
      let(:notices) { nil }
      let(:supports_ignore) { true }
      let(:deployable) { true }


      before do
        allow(PactBroker::Client::Matrix::Query).to receive(:call).and_return(matrix)
        allow(Matrix::Formatter).to receive(:call).and_return('text matrix')
      end

      subject { CanIDeploy.call(version_selectors, matrix_options, options, pact_broker_client_options) }

      it "retrieves the matrix from the pact broker" do
        expect(PactBroker::Client::Matrix::Query).to receive(:call).with({ selectors: version_selectors, matrix_options: matrix_options }, options, pact_broker_client_options)
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

        context "when there are notices" do
          let(:notices) { [Notice.new(text: "some notice", type: "info")] }

          it "returns the notices instead of the reason" do
            expect(subject.message).to_not include "some reason"
            expect(subject.message).to include "some notice"
          end
        end

        context "when dry_run is enabled" do
          let(:dry_run) { true }

          it "prefixes each line with [dry-run]" do
            Approvals.verify(subject.message, :name => "can_i_deploy_success_dry_run", format: :txt)
          end
        end
      end

      context "when the versions are not deployable" do
        let(:matrix) { instance_double('Matrix::Resource', deployable?: false, reason: 'some reason', any_unknown?: false, notices: notices) }

        it "returns a failure response" do
          expect(subject.success).to be false
        end

        it "returns a failure message" do
          expect(subject.message).to include "Computer says no"
        end

        it "returns a failure reason" do
          expect(subject.message).to include "some reason"
        end

        context "when there are notices" do
          let(:notices) { [Notice.new(text: "some notice", type: "info")] }

          it "returns the notices instead of the reason" do
            expect(subject.message).to_not include "some reason"
            expect(subject.message).to include "some notice"
          end
        end

        context "when dry_run is enabled" do
          let(:dry_run) { true }

          it "returns a success response" do
            expect(subject.success).to be true
          end

          it "prefixes each line with [dry-run]" do
            Approvals.verify(subject.message, :name => "can_i_deploy_failure_dry_run", format: :txt)
          end
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

          let(:unknown_count) { 1 }

          it "puts a message to stderr" do
            expect($stderr).to receive(:puts).with("Waiting for 1 verification result to be published (maximum of 5 seconds)")
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

          context "when dry_run is enabled" do
            let(:dry_run) { true }

            it "returns a success response" do
              expect(subject.success).to be true
            end

            it "returns a success message" do
              expect(subject.message).to include "[dry-run]"
              expect(subject.message).to match /Dry run enabled - ignoring any failures/
            end
          end
        end
      end

      context "when there are ignore selectors but the matrix does not support ignoring" do
        let(:matrix_options) { { ignore_selectors: [{ pacticipant_name: "Foo" }]} }
        let(:supports_ignore) { false }

        context "when deployable" do
          it "returns a warning" do
            expect(subject.message).to include "does not support"
          end
        end

        context "when not deployable" do
          let(:deployable) { false }

          it "returns a warning" do
            expect(subject.message).to include "does not support"
          end
        end
      end

      context "when a PactBroker::Client::Error is raised" do
        before do
          allow(PactBroker::Client::Matrix::Query).to receive(:call).and_raise(PactBroker::Client::Error.new('error text'))
        end

        it "returns a failure response" do
          expect(subject.success).to be false
        end

        it "returns a failure message" do
          expect(subject.message).to include "error text"
        end

        context "when dry_run is enabled" do
          let(:dry_run) { true }

          it "returns a success response" do
            expect(subject.success).to be true
          end

          it "returns a failure message" do
            expect(subject.message).to include "[dry-run]"
            expect(subject.message).to match /error text/
          end
        end
      end

      context "when a StandardError is raised" do
        before do
          allow(Retry).to receive(:while_error) { |&block| block.call }
          allow($stderr).to receive(:puts)
          allow(PactBroker::Client::Matrix::Query).to receive(:call).and_raise(StandardError.new('error text'))
        end

        it "returns a failure response" do
          expect(subject.success).to be false
        end

        it "returns a failure message and backtrace" do
          expect(subject.message).to include "Error retrieving matrix. StandardError - error text"
        end

        context "when dry_run is enabled" do
          let(:dry_run) { true }

          it "returns a success response" do
            expect(subject.success).to be true
          end

          it "returns a failure message" do
            expect(subject.message).to include "[dry-run]"
            expect(subject.message).to match /error text/
          end
        end
      end
    end
  end
end
