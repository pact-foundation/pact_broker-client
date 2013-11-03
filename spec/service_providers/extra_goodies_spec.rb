require 'spec_helper'

=begin
{
    "_links": [
        "self": { "href": "http://localhost/pacticipants" },
        "item": [
            { "href": "http://localhost:1234/pacticipants/Condor", "name": "Condor" },
            { "href": "http://localhost:1234/pacticipants/Pricing%20Service", "name": "Pricing Service" }
        ]
    ],
    "_embedded": [
        {
            "name": "Condor",
            "repository_url": nil,
            "_links": [
                "self": { "href": "http://localhost:1234/pacticipants/Condor" },
                "http://pact-broker.com/rels#last_version": "http://localhost:1234/pacticipants/Condor/versions/last"
            ]
        },
        {
            "name": "Pricing Service",
            "repository_url": "git@git.realestate.com.au:business-systems/pricing-service"
            "_links": [
                "self": { "href": "http://localhost:1234/pacticipants/Pricing%20Service" },
                "http://pact-broker.com/rels#last_version": "http://localhost:1234/pacticipants/Pricing%20Service/versions/last"
            ]
        }
    ]
}
=end

module PactBroker::Client
  describe PactBrokerClient, :pact => true do

    describe "listing the pacticipants" do

    end
  end
end