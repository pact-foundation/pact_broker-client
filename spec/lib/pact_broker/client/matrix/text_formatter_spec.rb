require 'pact_broker/client/matrix/text_formatter'

module PactBroker
  module Client
    describe Matrix::TextFormatter do
      let(:matrix_lines) { JSON.parse(File.read('spec/support/matrix.json'), symbolize_names: true) }
      let(:expected_matrix_lines) { File.read('spec/support/matrix.txt') }

      # SublimeText removes whitespace from the end of files when you save them,
      # so removing trailing whitespace before comparing
      subject { Matrix::TextFormatter.call(matrix_lines).split("\n").collect(&:strip).join("\n") }

      context "with valid data" do
        it "it has the right text" do
          expect(subject).to eq expected_matrix_lines
        end
      end

      context "with invalid data" do
        let(:expected_matrix_lines) { File.read('spec/support/matrix_error.txt') }
        let(:matrix_lines) { [{}] }

        it "doesn't blow up" do
          expect(subject).to eq expected_matrix_lines
        end
      end
    end
  end
end
