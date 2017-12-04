require 'spec_helper'
require 'pact/consumer/rspec'


Pact.configure do | config |
  config.logger.level = Logger::DEBUG
  config.doc_generator = :markdown
end

Pact.service_consumer 'Pact Broker Client' do

  has_pact_with "Pact Broker" do
    mock_service :pact_broker do
      port 1234
      pact_specification_version "2.0"
    end
  end

end

