require 'pact_broker/client/retry'

module PactBroker
  module Client
    describe Retry do
      describe ".until_truthy_or_max_times" do
        before do
          allow(service).to receive(:get_result).and_return(1, 2, 3)
          allow(condition).to receive(:call).and_return(false, false, true)
          allow(Retry).to receive(:sleep)
        end

        let(:service) { double('service') }
        let(:condition) { double('condition') }
        let(:times) { 4 }
        let(:sleep_first) { nil }

        subject do
          Retry.until_truthy_or_max_times(condition: condition, times: times, sleep: 3, sleep_first: sleep_first) do
            service.get_result
          end
        end

        context "times is 0 (which it shouldn't be, but just to be sure...)" do
          let(:times) { 0 }

          it "only executes the block once" do
            subject
            expect(service).to have_received(:get_result).exactly(1).times
          end

          it "does not execute the condition" do
            expect(condition).to_not receive(:call)
            subject
          end

          it "returns the result" do
            expect(subject).to eq 1
          end
        end

        context "times is 1" do
          let(:times) { 1 }

          it "only executes the block once" do
            subject
            expect(service).to have_received(:get_result).exactly(1).times
          end

          it "does not execute the condition" do
            expect(condition).to_not receive(:call)
            subject
          end

          it "returns the result" do
            expect(subject).to eq 1
          end
        end

        context "when the condition becomes true before the max tries" do
          it "stops retrying when the condition becomes true" do
            subject
            expect(condition).to have_received(:call).exactly(3).times
            expect(service).to have_received(:get_result).exactly(3).times
          end

          it "returns the most recent result" do
            expect(subject).to eq 3
          end
        end

        context "when the max tries is reached before the condition becomes true" do
          let(:times) { 2 }

          it "stops retrying once the max tries is reached" do
            subject
            expect(condition).to have_received(:call).exactly(2).times
            expect(service).to have_received(:get_result).exactly(2).times
          end

          it "returns the most recent result" do
            expect(subject).to eq 2
          end
        end

        context "when an error is raised each time" do
          TestError = Class.new(StandardError)

          before do
            allow(service).to receive(:get_result).and_raise(TestError)
            allow($stderr).to receive(:puts)
          end

          it "stops retrying once the max tries is reached" do
            begin
              subject
            rescue TestError
            end
            expect(service).to have_received(:get_result).exactly(4).times
          end

          it "raises the error" do
            expect { subject }.to raise_error TestError
          end
        end

        context "when sleep_first is true" do
          let(:sleep_first) { true }

          it "sleeps before it executes the block" do
            expect(Retry).to receive(:sleep).ordered
            expect(service).to receive(:get_result).ordered
            subject
          end
        end
      end
    end
  end
end
