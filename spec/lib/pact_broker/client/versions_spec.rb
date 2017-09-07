require 'pact_broker/client/versions'
module PactBroker
  module Client
    describe Versions do
      let(:client_options) do
        { some_option: 'option value'}
      end
      let(:base_url) { 'http://blah' }
      let(:pacticipant_name) { 'Foo' }
      let(:version_number) { '1.2.3' }

      subject { Versions.new(base_url: base_url, client_options: client_options) }

      describe 'pacts' do
        it 'initializes versions with base url and client options' do
          expect(PactBroker::Client::Pacts).to receive(:new).with(base_url: base_url, client_options: client_options)
          subject.pacts
        end
      end

      describe 'tag' do
        context "when the tag has a / in it" do
          let(:tag) { 'feat/foo' }
          let!(:request) { stub_request(:put, "http://blah/pacticipants/Foo/versions/1.2.3/tags/feat%2Ffoo").to_return(status: 200) }

          it "URL encodes the /" do
            subject.tag(pacticipant: pacticipant_name, version: version_number, tag: tag)
            expect(request).to have_been_made
          end
        end
      end
    end
  end
end