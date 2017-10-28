describe "pact-broker can-i-deploy" do
  before(:all) do
    @pipe = IO.popen("bundle exec pact-stub-service spec/pacts/pact_broker_client-pact_broker.json -p 5000")
    sleep 2
  end

  context "when the pacticipants can be deployed" do
    subject { `bundle exec bin/pact-broker can-i-deploy -v --pacticipant Foo --version 1.2.3 --pacticipant Bar --version 4.5.6 --broker-base-url http://localhost:5000` }

    it "returns a success exit code" do
      subject
      expect($?.exitstatus).to eq 0
      expect(subject).to match /CONSUMER/
      expect(subject).to match /Foo/
      expect(subject).to match /PROVIDER/
      expect(subject).to match /Bar/
    end
  end

  context "when the pacticipants can't be deployed" do
    subject { `bundle exec bin/pact-broker can-i-deploy -v --pacticipant Wiffle --version 1.2.3 --pacticipant Meep --version 4.5.6 --broker-base-url http://localhost:5000` }

    it "returns an error exit code" do
      subject
      expect($?.exitstatus).to_not eq 0
    end
  end

  after(:all) do
    Process.kill 'KILL', @pipe.pid
  end
end
