
require 'pact_broker/client/matrix/abbreviate_version_number'

module PactBroker
  module Client
    describe Matrix::AbbreviateVersionNumber do
      describe '.call' do
        subject(:result) { described_class.call(version) }

        context 'when version is nil' do
          let(:version) { nil }
          it { is_expected.to be_nil }
        end

        context 'when version is git sha' do
          let(:version) { '182f9c6e4d7a5779c4507cb8b3e505ac927d0394' }
          it { is_expected.to eq('182f9c6...') }
        end

        context 'when version is too long' do
          let(:version) { '182f9c6e4d7a5779c4507cb8b3e505ac927d0394' * 2 }
          it { is_expected.to eq(version[0...60] + '...') }
        end

        context 'when the version is something unknown and fits max length' do
          let(:version) { '123' }
          it { is_expected.to eq('123') }
        end

        context 'when version is embedded into semantic version v1' do
          let(:version) { 'v1.3.4+182f9c6e4d7a5779c4507cb8b3e505ac927d0394' }
          it { is_expected.to eq('v1.3.4+182f9c6...') }
        end

        context 'when version is embedded into semantic version v2' do
          let(:version) { '1.3.4(182f9c6e4d7a5779c4507cb8b3e505ac927d0394)' }
          it { is_expected.to eq('1.3.4(182f9c6...)') }
        end
      end
    end
  end
end
