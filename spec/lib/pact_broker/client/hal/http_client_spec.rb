require 'pact_broker/client/hal/http_client'
require "faraday"
require "faraday/retry"

module PactBroker::Client
  module Hal
    describe HttpClient do
      subject { HttpClient.new(username: 'foo', password: 'bar') }

      describe "get" do
        before do
          allow(subject).to receive(:until_truthy_or_max_times) { |&block| block.call }
        end

        let!(:request) do
          stub_request(:get, "http://example.org/").
            with(  headers: {
              'Accept'=>'application/hal+json',
              'Authorization'=>'Basic Zm9vOmJhcg=='
              }).
            to_return(status: 200, body: response_body, headers: {'Content-Type' => 'application/json'})
        end

        let(:response_body) { {some: 'json'}.to_json }
        let(:do_get) { subject.get('http://example.org') }

        it "performs a get request" do
          do_get
          expect(request).to have_been_made
        end

        context "with get params" do
          let!(:request) do
            stub_request(:get, "http://example.org/?foo=hello+world&bar=wiffle").
              to_return(status: 200)
          end

          let(:do_get) { subject.get('http://example.org', { 'foo' => 'hello world', 'bar' => 'wiffle' }) }

          it "correctly converts and encodes get params" do
             do_get
             expect(request).to have_been_made
          end
        end

        it "retries on failure" do
          expect(subject).to receive(:until_truthy_or_max_times)
          do_get
        end

        it "returns a response" do
          expect(do_get.body).to eq({"some" => "json"})
        end

      end

      describe "post" do
        before do
          allow(subject).to receive(:until_truthy_or_max_times) { |&block| block.call }
        end

        let!(:request) do
          stub_request(:post, "http://example.org/").
            with(  headers: {
              'Accept'=>'application/hal+json',
              'Authorization'=>'Basic Zm9vOmJhcg==',
              'Content-Type'=>'application/json'
              },
              body: request_body).
            to_return(status: 200, body: response_body, headers: {'Content-Type' => 'application/json'})
        end

        let(:request_body) { {some: 'data'}.to_json }
        let(:response_body) { {some: 'json'}.to_json }

        let(:do_post) { subject.post('http://example.org/', request_body) }

        it "performs a post request" do
          do_post
          expect(request).to have_been_made
        end

        it "calls Retry.until_truthy_or_max_times" do
          expect(subject).to receive(:until_truthy_or_max_times)
          do_post
        end

        it "returns a response" do
          expect(do_post.body).to eq({"some" => "json"})
        end

        context "with custom headers" do
          let!(:request) do
            stub_request(:post, "http://example.org/").
              with(  headers: {
                'Accept'=>'foo'
                }).
              to_return(status: 200)
          end

          let(:do_post) { subject.post('http://example.org/', request_body, {"Accept" => "foo"} ) }

          it "performs a post request with custom headers" do
            do_post
            expect(request).to have_been_made
          end
        end
      end

      describe "integration test" do
        before do
          allow(subject).to receive(:sleep)
        end

        let(:do_get) { subject.get('http://example.org') }

        context "with a 50x error is returned less than the max number of tries" do
          let!(:request) do
            stub_request(:get, "http://example.org").
              to_return({ status: 500 }, { status: 502 }, { status: 503 }, { status: 200 })
          end

          it "retries" do
            expect(do_get.status).to eq 200
          end
        end

        context "with a 50x error is returned more than the max number of tries" do
          let!(:request) do
            stub_request(:get, "http://example.org").
              to_return({ status: 500 }, { status: 501 }, { status: 502 }, { status: 503 }, { status: 504 })
          end

          it "retries and returns the last 50x response" do
            expect(do_get.status).to eq 504
          end
        end

        context "when exceptions are raised" do
          before do
            allow($stderr).to receive(:puts)
          end

          let!(:request) do
            stub_request(:get, "http://example.org")
              .to_raise(Errno::ECONNREFUSED)
          end

          it "logs the error" do
            expect($stderr).to receive(:puts).with(/Errno::ECONNREFUSED/)
            begin
              do_get
            rescue Errno::ECONNREFUSED
            end
          end

          it "retries and raises the last exception" do
            expect { do_get }.to raise_error(Errno::ECONNREFUSED)
          end
        end
      end

      describe "x509 certificate" do
        FAKE_SERVER_URL = 'https://localhost:4444'
        X509_CERT_FILE_PATH = './spec/fixtures/certificates/client_cert.pem'
        X509_KEY_FILE_PATH = './spec/fixtures/certificates/key.pem'
        UNSIGNED_X509_CERT_FILE_PATH = './spec/fixtures/certificates/unsigned_cert.pem'
        UNSIGNED_X509_KEY_FILE_PATH = './spec/fixtures/certificates/unsigned_key.pem'

        def wait_for_server_to_start
          Faraday.new(
            url: FAKE_SERVER_URL,
            ssl: {
              verify: false,
              client_cert: OpenSSL::X509::Certificate.new(File.read(X509_CERT_FILE_PATH)),
              client_key: OpenSSL::PKey::RSA.new(File.read(X509_KEY_FILE_PATH))
            }
          ) do |builder|
            builder.request :retry, max: 20, interval: 0.5, exceptions: [StandardError]
            builder.adapter :net_http
          end.get
        end

        let(:do_get) { subject.get(FAKE_SERVER_URL) }

        before(:all) do
          @pipe = IO.popen("bundle exec ruby ./spec/support/ssl_server.rb")
          ENV['SSL_CERT_FILE'] = "./spec/fixtures/certificates/ca_cert.pem"
          ENV['SSL_CERT_DIR'] =  "./spec/fixtures/certificates/"

          wait_for_server_to_start()
        end

        context "with valid x509 client certificates" do
          before do
            ENV['X509_CLIENT_CERT_FILE'] = X509_CERT_FILE_PATH
            ENV['X509_CLIENT_KEY_FILE'] = X509_KEY_FILE_PATH
          end

          it "succeeds" do
            expect(do_get.status).to eq 200
          end
        end

        context "when invalid x509 certificates are set" do
          before do
            ENV['X509_CLIENT_CERT_FILE'] = UNSIGNED_X509_CERT_FILE_PATH
            ENV['X509_CLIENT_KEY_FILE'] = UNSIGNED_X509_KEY_FILE_PATH
          end

          it "fails raising SSL error" do
            expect { do_get }
              .to raise_error(OpenSSL::SSL::SSLError, /tlsv1 alert unknown ca/)
          end
        end

        context "when no x509 certificates are set" do
          before do
            ENV['X509_CLIENT_CERT_FILE'] = nil
            ENV['X509_CLIENT_KEY_FILE'] = nil
          end

          it "fails raising SSL error" do
            expect { do_get }
              .to raise_error(OpenSSL::SSL::SSLError, /tlsv13 alert certificate required/)
          end
        end

        after(:all) do
          Process.kill "KILL", @pipe.pid
        end
      end
    end
  end
end
