require 'pact_broker/client/hal/link'
require 'pact_broker/client/hal/entity'
require 'pact_broker/client/hal/http_client'

module PactBroker::Client
  module Hal
    describe Link do
      before do
        allow(response).to receive(:header).with("Content-Type").and_return(content_type)
      end

      let(:http_client) do
        instance_double('PactBroker::Client::Hal::HttpClient', post: response)
      end

      let(:response) do
        instance_double('PactBroker::Client::Hal::HttpClient::Response', success?: success, body: response_body, raw_body: response_body.to_json)
      end

      let(:success) { true }

      let(:entity) do
        instance_double('PactBroker::Client::Hal::Entity')
      end

      let(:attrs) do
        {
          'href' => 'http://foo/{bar}',
          'title' => 'title',
          method: :post
        }
      end

      let(:response_body) do
        {
          'some' => 'body'
        }
      end

      let(:content_type) { nil }

      subject { Link.new(attrs, http_client) }

      before do
        allow(PactBroker::Client::Hal::Entity).to receive(:new).and_return(entity)
      end

      describe "#run" do
        let(:do_run) { subject.run('foo' => 'bar') }

        it "executes the configured http request" do
          expect(http_client).to receive(:post)
          do_run
        end

        it "creates an Entity" do
          expect(PactBroker::Client::Hal::Entity).to receive(:new).with("http://foo/{bar}", response_body, http_client, response)
          do_run
        end

        it "returns an Entity" do
          expect(do_run).to eq entity
        end

        context "when an error response is returned" do
          before do
            allow(PactBroker::Client::Hal::ErrorEntity).to receive(:new).and_return(entity)
          end

          let(:success) { false }

          it "creates an ErrorEntity" do
            expect(PactBroker::Client::Hal::ErrorEntity).to receive(:new).with("http://foo/{bar}", response_body.to_json, http_client, response)
            do_run
          end

          context "when a JSON error is returned" do
            let(:content_type) { "application/json" }

            it "parses the response body" do
              expect(PactBroker::Client::Hal::ErrorEntity).to receive(:new).with("http://foo/{bar}", response_body, http_client, response)
              do_run
            end
          end
        end
      end

      describe "#get" do
        before do
          allow(http_client).to receive(:get).and_return(response)
        end

        let(:do_get) { subject.get({ 'foo' => 'bar' }) }

        it "executes an HTTP Get request" do
          expect(http_client).to receive(:get).with('http://foo/{bar}', { 'foo' => 'bar' }, {})
          do_get
        end
      end

      describe "#post" do
        let(:do_post) { subject.post({ 'foo' => 'bar' }, { 'Accept' => 'foo' }) }

        context "with custom headers" do
          it "executes an HTTP Post request with the custom headers" do
            expect(http_client).to receive(:post).with('http://foo/{bar}', '{"foo":"bar"}', { 'Accept' => 'foo' })
            do_post
          end
        end
      end

      describe "#expand" do
        it "returns a duplicate Link with the expanded href" do
          expect(subject.expand(bar: 'wiffle').href).to eq "http://foo/wiffle"
        end

        it "returns a duplicate Link with the expanded href with URL escaping" do
          expect(subject.expand(bar: 'wiffle meep').href).to eq "http://foo/wiffle%20meep"
        end

        it "returns a duplicate Link with the expanded href with URL escaping for forward slashes" do
          expect(subject.expand(bar: 'wiffle/meep').href).to eq "http://foo/wiffle%2Fmeep"
        end
      end
    end
  end
end
