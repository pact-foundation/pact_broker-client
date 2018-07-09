require 'pact_broker/client/matrix/resource'

module PactBroker
  module Client
    class Matrix
      describe Resource do

        let(:matrix_hash) { JSON.parse(File.read('spec/support/matrix.json'), symbolize_names: true) }

        subject { Resource.new(matrix_hash) }

        describe "any_unknown?" do
          context "when $summary.unknown is greater than 0" do
            it "is true" do
              expect(subject.any_unknown?).to be true
            end
          end

          context "when $summary.unknown is 0" do
            before do
              matrix_hash[:summary][:unknown] = 0
            end

            it "is false" do
              expect(subject.any_unknown?).to be false
            end
          end
        end

        describe "supports_unknown_count?" do
          context "when $summary.unknown is present" do
            it "is true" do
              expect(subject.supports_unknown_count?).to be true
            end
          end

          context "when $summary.unknown is nil" do
            before do
              matrix_hash[:summary][:unknown] = nil
            end

            it "is false" do
              expect(subject.supports_unknown_count?).to be false
            end
          end

          context "when $summary.unknown is not an Integer" do
            before do
              matrix_hash[:summary][:unknown] = true
            end

            it "is false" do
              expect(subject.supports_unknown_count?).to be false
            end
          end

          context "when $summary.unknown is not present" do
            before do
              matrix_hash[:summary].delete(:unknown)
            end

            it "is false" do
              expect(subject.supports_unknown_count?).to be false
            end
          end
        end
      end
    end
  end
end