describe "pact-broker can-i-deploy", skip_windows: true do
  before(:all) do
    @pipe = IO.popen("bundle exec pact-stub-service spec/pacts/pact_broker_client-pact_broker.json -p 5000 --log tmp/pact-stub-can-i-deploy.log")
    sleep 4
  end

  context "when the pacticipants can be deployed" do
    subject { `bundle exec bin/pact-broker can-i-deploy --pacticipant Foo --version 1.2.3 --pacticipant Bar --version 4.5.6 --broker-base-url http://localhost:5000` }

    it "returns a success exit code" do
      subject
      puts subject unless $?.exitstatus == 0
      expect($?.exitstatus).to eq 0
      expect(subject).to match /CONSUMER/
      expect(subject).to match /Foo/
      expect(subject).to match /PROVIDER/
      expect(subject).to match /Bar/
    end
  end

  after(:all) do
    Process.kill 'KILL', @pipe.pid
  end
end
