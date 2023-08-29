require 'pact_broker/client/matrix/resource'
require 'pact_broker/client/matrix/text_formatter'

module PactBroker
  module Client
    describe Matrix::TextFormatter do
      let(:matrix) { PactBroker::Client::Matrix::Resource.new(JSON.parse(File.read('spec/support/matrix.json'), symbolize_names: true)) }
      let(:expected_matrix_lines) { File.read('spec/support/matrix.txt') }

      # SublimeText removes whitespace from the end of files when you save them,
      # so removing trailing whitespace before comparing
      def strip_trailing_whitespace(text)
        text.split("\n").collect(&:strip).join("\n")
      end

      subject { strip_trailing_whitespace(Matrix::TextFormatter.call(matrix)) }

      context "with valid data" do
        it "it has the right text" do
          expect(subject).to start_with expected_matrix_lines
        end
      end

      context "with invalid data" do
        let(:expected_matrix_lines) { File.read('spec/support/matrix_error.txt') }
        let(:matrix) { PactBroker::Client::Matrix::Resource.new(matrix: [{}]) }

        it "doesn't blow up" do
          expect(subject).to eq expected_matrix_lines
        end
      end

      context "when some rows have a verification result URL and some don't" do
        let(:matrix_lines) do
          line_creator = -> { JSON.parse(File.read('spec/support/matrix.json'), symbolize_names: true)[:matrix].first }
          line_1 = line_creator.call
          line_2 = line_creator.call
          line_3 = line_creator.call

          # ensure the data is as expected
          expect(line_1.dig(:consumer, :version, :number)).to_not be nil
          expect(line_1.dig(:provider, :version, :number)).to_not be nil

          line_1[:consumer][:version][:number] = "4"
          line_2[:consumer][:version][:number] = "3"
          line_3[:consumer][:version][:number] = "5"

          line_2[:verificationResult] = nil
          line_3[:verificationResult][:success] = false
          [line_1, line_2, line_3].shuffle
        end

        let(:matrix) { PactBroker::Client::Matrix::Resource.new(matrix: matrix_lines) }

        let(:expected_matrix_lines) { File.read('spec/support/matrix_with_results.txt') }

        it "only provides a result number for the lines that have a result URL" do
          expect(subject).to eq expected_matrix_lines
        end
      end
    end
  end
end
