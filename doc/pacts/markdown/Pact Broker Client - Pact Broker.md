### A pact between Pact Broker Client and Pact Broker

#### Requests from Pact Broker Client to Pact Broker

* [A request for the compatibility matrix for a pacticipant that does not exist](#a_request_for_the_compatibility_matrix_for_a_pacticipant_that_does_not_exist)

* [A request for the compatibility matrix for all versions of Foo and Bar](#a_request_for_the_compatibility_matrix_for_all_versions_of_Foo_and_Bar_given_the_pact_for_Foo_version_1.2.3_and_1.2.4_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 and 1.2.4 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_Thing_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo Thing version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix for Foo version 1.2.3 and the latest prod version of Bar](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_version_of_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_with_tag_prod,_and_1.2.4_unsuccessfully_by_9.9.9) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 with tag prod, and 1.2.4 unsuccessfully by 9.9.9

* [A request for the compatibility matrix for Foo version 1.2.3 and the latest prod versions of all other pacticipants](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_versions_of_all_other_pacticipants_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_(tagged_prod)_and_version_5.6.7) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 (tagged prod) and version 5.6.7

* [A request for the compatibility matrix for Foo version 1.2.3 and the latest version of Bar](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_version_of_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6,_and_1.2.4_unsuccessfully_by_9.9.9) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9

* [A request for the compatibility matrix where one or more versions does not exist](#a_request_for_the_compatibility_matrix_where_one_or_more_versions_does_not_exist_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix where only the version of Foo is specified](#a_request_for_the_compatibility_matrix_where_only_the_version_of_Foo_is_specified_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6_and_version_5.6.7) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6 and version 5.6.7

* [A request for the index resource](#a_request_for_the_index_resource)

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pacticipant_relations_are_present) given the pacticipant relations are present

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:latest-tagged-version_relation_exists_in_the_index_resource) given the pb:latest-tagged-version relation exists in the index resource

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:latest-version_relation_exists_in_the_index_resource) given the pb:latest-version relation exists in the index resource

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:pacticipant-version_relation_exists_in_the_index_resource) given the pb:pacticipant-version relation exists in the index resource

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:publish-contracts_relations_exists_in_the_index_resource) given the pb:publish-contracts relations exists in the index resource

* [A request for the index resource with the webhook relation](#a_request_for_the_index_resource_with_the_webhook_relation)

* [A request for the list of the latest pacts from all consumers for the Pricing Service'](#a_request_for_the_list_of_the_latest_pacts_from_all_consumers_for_the_Pricing_Service&#39;_given_a_latest_pact_between_Condor_and_the_Pricing_Service_exists) given a latest pact between Condor and the Pricing Service exists

* [A request for the list of the latest prod pacts from all consumers for the Pricing Service'](#a_request_for_the_list_of_the_latest_prod_pacts_from_all_consumers_for_the_Pricing_Service&#39;_given_tagged_as_prod_pact_between_Condor_and_the_Pricing_Service_exists) given tagged as prod pact between Condor and the Pricing Service exists

* [A request for the successful rows of the compatibility matrix for all versions of Foo and Bar](#a_request_for_the_successful_rows_of_the_compatibility_matrix_for_all_versions_of_Foo_and_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6,_and_1.2.4_unsuccessfully_by_9.9.9) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9

* [A request retrieve a pact for a specific version](#a_request_retrieve_a_pact_for_a_specific_version_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0) given the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0

* [A request to create a global webhook with a JSON body](#a_request_to_create_a_global_webhook_with_a_JSON_body)

* [A request to create a pacticipant](#a_request_to_create_a_pacticipant)

* [A request to create a pacticipant version](#a_request_to_create_a_pacticipant_version_given_version_26f353580936ad3b9baddb17b00e84f33c69e7cb_of_pacticipant_Foo_does_exist) given version 26f353580936ad3b9baddb17b00e84f33c69e7cb of pacticipant Foo does exist

* [A request to create a pacticipant version](#a_request_to_create_a_pacticipant_version_given_version_26f353580936ad3b9baddb17b00e84f33c69e7cb_of_pacticipant_Foo_does_not_exist) given version 26f353580936ad3b9baddb17b00e84f33c69e7cb of pacticipant Foo does not exist

* [A request to create a webhook for a consumer and provider](#a_request_to_create_a_webhook_for_a_consumer_and_provider_given_&#39;Condor&#39;_does_not_exist_in_the_pact-broker) given 'Condor' does not exist in the pact-broker

* [A request to create a webhook with a JSON body and a uuid](#a_request_to_create_a_webhook_with_a_JSON_body_and_a_uuid_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with a JSON body for a consumer](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with a JSON body for a consumer and provider](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with a JSON body for a consumer that does not exist](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_that_does_not_exist)

* [A request to create a webhook with a JSON body for a provider](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with a non-JSON body for a consumer and provider](#a_request_to_create_a_webhook_with_a_non-JSON_body_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with every possible event type](#a_request_to_create_a_webhook_with_every_possible_event_type_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to get the Pricing Service](#a_request_to_get_the_Pricing_Service_given_the_&#39;Pricing_Service&#39;_already_exists_in_the_pact-broker) given the 'Pricing Service' already exists in the pact-broker

* [A request to get the Pricing Service](#a_request_to_get_the_Pricing_Service_given_the_&#39;Pricing_Service&#39;_does_not_exist_in_the_pact-broker) given the 'Pricing Service' does not exist in the pact-broker

* [A request to list pacticipants](#a_request_to_list_pacticipants_given_&#39;Condor&#39;_exists_in_the_pact-broker) given 'Condor' exists in the pact-broker

* [A request to list the latest pacts](#a_request_to_list_the_latest_pacts_given_a_pact_between_Condor_and_the_Pricing_Service_exists) given a pact between Condor and the Pricing Service exists

* [A request to publish a pact](#a_request_to_publish_a_pact_given_&#39;Condor&#39;_already_exist_in_the_pact-broker,_but_the_&#39;Pricing_Service&#39;_does_not) given 'Condor' already exist in the pact-broker, but the 'Pricing Service' does not

* [A request to publish a pact](#a_request_to_publish_a_pact_given_the_&#39;Pricing_Service&#39;_already_exists_in_the_pact-broker) given the 'Pricing Service' already exists in the pact-broker

* [A request to publish a pact](#a_request_to_publish_a_pact_given_an_error_occurs_while_publishing_a_pact) given an error occurs while publishing a pact

* [A request to publish a pact with method patch](#a_request_to_publish_a_pact_with_method_patch_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0) given the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0

* [A request to publish a pact with method put](#a_request_to_publish_a_pact_with_method_put_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0) given the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0

* [A request to publish contracts](#a_request_to_publish_contracts)

* [A request to register the repository URL of a pacticipant](#a_request_to_register_the_repository_URL_of_a_pacticipant_given_the_&#39;Pricing_Service&#39;_already_exists_in_the_pact-broker) given the 'Pricing Service' already exists in the pact-broker

* [A request to register the repository URL of a pacticipant](#a_request_to_register_the_repository_URL_of_a_pacticipant_given_the_&#39;Pricing_Service&#39;_does_not_exist_in_the_pact-broker) given the 'Pricing Service' does not exist in the pact-broker

* [A request to retrieve a pacticipant](#a_request_to_retrieve_a_pacticipant_given_a_pacticipant_with_name_Foo_exists) given a pacticipant with name Foo exists

* [A request to retrieve a pacticipant](#a_request_to_retrieve_a_pacticipant)

* [A request to retrieve the latest 'production' version of Condor](#a_request_to_retrieve_the_latest_&#39;production&#39;_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker_with_the_latest_tagged_&#39;production&#39;_version_1.2.3) given 'Condor' exists in the pact-broker with the latest tagged 'production' version 1.2.3

* [A request to retrieve the latest pact between Condor and the Pricing Service](#a_request_to_retrieve_the_latest_pact_between_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists) given a pact between Condor and the Pricing Service exists

* [A request to retrieve the latest pact between Condor and the Pricing Service](#a_request_to_retrieve_the_latest_pact_between_Condor_and_the_Pricing_Service_given_no_pact_between_Condor_and_the_Pricing_Service_exists) given no pact between Condor and the Pricing Service exists

* [A request to retrieve the latest version of Condor](#a_request_to_retrieve_the_latest_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker_with_the_latest_version_1.2.3) given 'Condor' exists in the pact-broker with the latest version 1.2.3

* [A request to retrieve the pact between the production verison of Condor and the Pricing Service](#a_request_to_retrieve_the_pact_between_the_production_verison_of_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists_for_the_production_version_of_Condor) given a pact between Condor and the Pricing Service exists for the production version of Condor

* [A request to tag the production version of Condor](#a_request_to_tag_the_production_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker_with_version_1.3.0,_tagged_with_&#39;prod&#39;) given 'Condor' exists in the pact-broker with version 1.3.0, tagged with 'prod'

* [A request to tag the production version of Condor](#a_request_to_tag_the_production_version_of_Condor_given_&#39;Condor&#39;_does_not_exist_in_the_pact-broker) given 'Condor' does not exist in the pact-broker

* [A request to tag the production version of Condor](#a_request_to_tag_the_production_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker) given 'Condor' exists in the pact-broker

* [A request to update a pacticipant](#a_request_to_update_a_pacticipant_given_a_pacticipant_with_name_Foo_exists) given a pacticipant with name Foo exists

* [A request to update a webhook](#a_request_to_update_a_webhook_given_a_webhook_with_the_uuid_696c5f93-1b7f-44bc-8d03-59440fcaa9a0_exists) given a webhook with the uuid 696c5f93-1b7f-44bc-8d03-59440fcaa9a0 exists

* [An invalid request to create a webhook for a consumer and provider](#an_invalid_request_to_create_a_webhook_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

#### Interactions

<a name="a_request_for_the_compatibility_matrix_for_a_pacticipant_that_does_not_exist"></a>
Upon receiving **a request for the compatibility matrix for a pacticipant that does not exist** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Wiffle&q%5B%5D%5Bversion%5D=1.2.3&q%5B%5D%5Bpacticipant%5D=Meep&q%5B%5D%5Bversion%5D=9.9.9&latestby=cvpv"
}
```
Pact Broker will respond with:
```json
{
  "status": 400,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "errors": [
      "an error message"
    ]
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_all_versions_of_Foo_and_Bar_given_the_pact_for_Foo_version_1.2.3_and_1.2.4_has_been_verified_by_Bar_version_4.5.6"></a>
Given **the pact for Foo version 1.2.3 and 1.2.4 has been verified by Bar version 4.5.6**, upon receiving **a request for the compatibility matrix for all versions of Foo and Bar** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bpacticipant%5D=Bar&latestby=cvpv"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "matrix": [
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "4"
          }
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "verifiedAt": "2017-10-10T12:49:04+11:00",
          "success": true,
          "_links": {
            "self": {
              "href": "http://result"
            }
          }
        },
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        }
      },
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "4"
          }
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "verifiedAt": "2017-10-10T12:49:04+11:00",
          "success": true,
          "_links": {
            "self": {
              "href": "http://result"
            }
          }
        },
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ]
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_Thing_version_1.2.3_has_been_verified_by_Bar_version_4.5.6"></a>
Given **the pact for Foo Thing version 1.2.3 has been verified by Bar version 4.5.6**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo%20Thing&q%5B%5D%5Bversion%5D=1.2.3&q%5B%5D%5Bpacticipant%5D=Bar&q%5B%5D%5Bversion%5D=4.5.6&latestby=cvpv"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    },
    "matrix": [
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "4"
          }
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "verifiedAt": "2017-10-10T12:49:04+11:00",
          "success": true,
          "_links": {
            "self": {
              "href": "http://result"
            }
          }
        },
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ]
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6"></a>
Given **the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bversion%5D=1.2.3&q%5B%5D%5Bpacticipant%5D=Bar&q%5B%5D%5Bversion%5D=4.5.6&latestby=cvpv"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    },
    "matrix": [
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "4"
          }
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "verifiedAt": "2017-10-10T12:49:04+11:00",
          "success": true,
          "_links": {
            "self": {
              "href": "http://result"
            }
          }
        },
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ]
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_version_of_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_with_tag_prod,_and_1.2.4_unsuccessfully_by_9.9.9"></a>
Given **the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 with tag prod, and 1.2.4 unsuccessfully by 9.9.9**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and the latest prod version of Bar** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bversion%5D=1.2.3&q%5B%5D%5Bpacticipant%5D=Bar&q%5B%5D%5Blatest%5D=true&q%5B%5D%5Btag%5D=prod&latestby=cvpv"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    },
    "matrix": [
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "4"
          }
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "verifiedAt": "2017-10-10T12:49:04+11:00",
          "success": true,
          "_links": {
            "self": {
              "href": "http://result"
            }
          }
        },
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ]
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_versions_of_all_other_pacticipants_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_(tagged_prod)_and_version_5.6.7"></a>
Given **the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 (tagged prod) and version 5.6.7**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and the latest prod versions of all other pacticipants** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bversion%5D=1.2.3&latestby=cvp&latest=true&tag=prod"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "matrix": [
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "1.2.3"
          }
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "4.5.6"
          }
        }
      }
    ]
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_version_of_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6,_and_1.2.4_unsuccessfully_by_9.9.9"></a>
Given **the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and the latest version of Bar** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bversion%5D=1.2.4&q%5B%5D%5Bpacticipant%5D=Bar&q%5B%5D%5Blatest%5D=true&latestby=cvpv"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    },
    "matrix": [
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "4"
          }
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "verifiedAt": "2017-10-10T12:49:04+11:00",
          "success": true,
          "_links": {
            "self": {
              "href": "http://result"
            }
          }
        },
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ]
  }
}
```
<a name="a_request_for_the_compatibility_matrix_where_one_or_more_versions_does_not_exist_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6"></a>
Given **the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6**, upon receiving **a request for the compatibility matrix where one or more versions does not exist** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bversion%5D=1.2.3&q%5B%5D%5Bpacticipant%5D=Bar&q%5B%5D%5Bversion%5D=9.9.9&latestby=cvpv"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "summary": {
      "reason": "an error message"
    }
  }
}
```
<a name="a_request_for_the_compatibility_matrix_where_only_the_version_of_Foo_is_specified_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6_and_version_5.6.7"></a>
Given **the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6 and version 5.6.7**, upon receiving **a request for the compatibility matrix where only the version of Foo is specified** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bversion%5D=1.2.3&latestby=cvp&latest=true"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    },
    "matrix": [
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "4"
          }
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "verifiedAt": "2017-10-10T12:49:04+11:00",
          "success": true,
          "_links": {
            "self": {
              "href": "http://result"
            }
          }
        },
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ]
  }
}
```
<a name="a_request_for_the_index_resource"></a>
Upon receiving **a request for the index resource** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/",
  "headers": {
    "Accept": "application/hal+json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:webhooks": {
        "href": "http://localhost:1234/HAL-REL-PLACEHOLDER-PB-WEBHOOKS"
      },
      "pb:pacticipants": {
        "href": "http://localhost:1234/HAL-REL-PLACEHOLDER-PB-PACTICIPANTS"
      },
      "pb:pacticipant": {
        "href": "http://localhost:1234/HAL-REL-PLACEHOLDER-PB-PACTICIPANT-{pacticipant}"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pacticipant_relations_are_present"></a>
Given **the pacticipant relations are present**, upon receiving **a request for the index resource** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/",
  "headers": {
    "Accept": "application/hal+json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:pacticipants": {
        "href": "http://localhost:1234/pacticipants"
      },
      "pb:pacticipant": {
        "href": "http://localhost:1234/pacticipants/{pacticipant}"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:latest-tagged-version_relation_exists_in_the_index_resource"></a>
Given **the pb:latest-tagged-version relation exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/",
  "headers": {
    "Accept": "application/hal+json, application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:latest-tagged-version": {
        "href": "http://localhost:1234/HAL-REL-PLACEHOLDER-INDEX-PB-LATEST-TAGGED-VERSION-{pacticipant}-{tag}"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:latest-version_relation_exists_in_the_index_resource"></a>
Given **the pb:latest-version relation exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/",
  "headers": {
    "Accept": "application/hal+json, application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:latest-version": {
        "href": "http://localhost:1234/HAL-REL-PLACEHOLDER-INDEX-PB-LATEST-VERSION-{pacticipant}"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:pacticipant-version_relation_exists_in_the_index_resource"></a>
Given **the pb:pacticipant-version relation exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/",
  "headers": {
    "Accept": "application/hal+json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:pacticipant-version": {
        "href": "http://localhost:1234/HAL-REL-PLACEHOLDER-INDEX-PB-PACTICIPANT-VERSION-{pacticipant}-{version}"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:publish-contracts_relations_exists_in_the_index_resource"></a>
Given **the pb:publish-contracts relations exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client, with
```json
{
  "method": "GET",
  "path": "/",
  "headers": {
    "Accept": "application/hal+json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:publish-contracts": {
        "href": "http://localhost:1234/HAL-REL-PLACEHOLDER-PB-PUBLISH-CONTRACTS"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_with_the_webhook_relation"></a>
Upon receiving **a request for the index resource with the webhook relation** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/",
  "headers": {
    "Accept": "application/hal+json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:webhook": {
        "href": "http://localhost:1234/webhooks/{uuid}",
        "templated": true
      }
    }
  }
}
```
<a name="a_request_for_the_list_of_the_latest_pacts_from_all_consumers_for_the_Pricing_Service&#39;_given_a_latest_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **a latest pact between Condor and the Pricing Service exists**, upon receiving **a request for the list of the latest pacts from all consumers for the Pricing Service'** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacts/provider/Pricing%20Service/latest"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "body": {
    "_links": {
      "provider": {
        "href": "http://example.org/pacticipants/Pricing%20Service",
        "title": "Pricing Service"
      },
      "pb:pacts": [
        {
          "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
          "title": "Pact between Condor (v1.3.0) and Pricing Service",
          "name": "Condor"
        }
      ]
    }
  }
}
```
<a name="a_request_for_the_list_of_the_latest_prod_pacts_from_all_consumers_for_the_Pricing_Service&#39;_given_tagged_as_prod_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **tagged as prod pact between Condor and the Pricing Service exists**, upon receiving **a request for the list of the latest prod pacts from all consumers for the Pricing Service'** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacts/provider/Pricing%20Service/latest/prod"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "body": {
    "_links": {
      "provider": {
        "href": "http://example.org/pacticipants/Pricing%20Service",
        "title": "Pricing Service"
      },
      "pb:pacts": [
        {
          "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
          "title": "Pact between Condor (v1.3.0) and Pricing Service",
          "name": "Condor"
        }
      ]
    }
  }
}
```
<a name="a_request_for_the_successful_rows_of_the_compatibility_matrix_for_all_versions_of_Foo_and_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6,_and_1.2.4_unsuccessfully_by_9.9.9"></a>
Given **the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9**, upon receiving **a request for the successful rows of the compatibility matrix for all versions of Foo and Bar** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bpacticipant%5D=Bar&latestby=cvpv&success%5B%5D=true"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    },
    "matrix": [
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "4"
          }
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "verifiedAt": "2017-10-10T12:49:04+11:00",
          "success": true,
          "_links": {
            "self": {
              "href": "http://result"
            }
          }
        },
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ]
  }
}
```
<a name="a_request_retrieve_a_pact_for_a_specific_version_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0**, upon receiving **a request retrieve a pact for a specific version** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "interactions": [

    ]
  }
}
```
<a name="a_request_to_create_a_global_webhook_with_a_JSON_body"></a>
Upon receiving **a request to create a global webhook with a JSON body** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/HAL-REL-PLACEHOLDER-PB-WEBHOOKS",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "description": "a webhook",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url",
        "title": "A title"
      }
    }
  }
}
```
<a name="a_request_to_create_a_pacticipant"></a>
Upon receiving **a request to create a pacticipant** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/pacticipants",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "name": "Foo",
    "repositoryUrl": "http://foo"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "name": "Foo",
    "repositoryUrl": "http://foo",
    "_links": {
      "self": {
        "href": "http://localhost:1234/pacticipants/Foo"
      }
    }
  }
}
```
<a name="a_request_to_create_a_pacticipant_version_given_version_26f353580936ad3b9baddb17b00e84f33c69e7cb_of_pacticipant_Foo_does_exist"></a>
Given **version 26f353580936ad3b9baddb17b00e84f33c69e7cb of pacticipant Foo does exist**, upon receiving **a request to create a pacticipant version** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/HAL-REL-PLACEHOLDER-INDEX-PB-PACTICIPANT-VERSION-Foo-26f353580936ad3b9baddb17b00e84f33c69e7cb",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "branch": "main",
    "buildUrl": "http://my-ci/builds/1"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "number": "26f353580936ad3b9baddb17b00e84f33c69e7cb",
    "branch": "main",
    "buildUrl": "http://my-ci/builds/1",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url"
      }
    }
  }
}
```
<a name="a_request_to_create_a_pacticipant_version_given_version_26f353580936ad3b9baddb17b00e84f33c69e7cb_of_pacticipant_Foo_does_not_exist"></a>
Given **version 26f353580936ad3b9baddb17b00e84f33c69e7cb of pacticipant Foo does not exist**, upon receiving **a request to create a pacticipant version** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/HAL-REL-PLACEHOLDER-INDEX-PB-PACTICIPANT-VERSION-Foo-26f353580936ad3b9baddb17b00e84f33c69e7cb",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "branch": "main",
    "buildUrl": "http://my-ci/builds/1"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "number": "26f353580936ad3b9baddb17b00e84f33c69e7cb",
    "branch": "main",
    "buildUrl": "http://my-ci/builds/1",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_for_a_consumer_and_provider_given_&#39;Condor&#39;_does_not_exist_in_the_pact-broker"></a>
Given **'Condor' does not exist in the pact-broker**, upon receiving **a request to create a webhook for a consumer and provider** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 404,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_and_a_uuid_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a JSON body and a uuid** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/webhooks/696c5f93-1b7f-44bc-8d03-59440fcaa9a0",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "consumer": {
      "name": "Condor"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "description": "a webhook",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url",
        "title": "A title"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a JSON body for a consumer** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/HAL-REL-PLACEHOLDER-PB-WEBHOOKS",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    },
    "consumer": {
      "name": "Condor"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "description": "a webhook",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url",
        "title": "A title"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a JSON body for a consumer and provider** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "description": "a webhook",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url",
        "title": "A title"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_that_does_not_exist"></a>
Upon receiving **a request to create a webhook with a JSON body for a consumer that does not exist** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/HAL-REL-PLACEHOLDER-PB-WEBHOOKS",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    },
    "consumer": {
      "name": "Condor"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 400,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "errors": {
      "consumer.name": [
        "Some error"
      ]
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_for_a_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a JSON body for a provider** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/HAL-REL-PLACEHOLDER-PB-WEBHOOKS",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    },
    "provider": {
      "name": "Pricing Service"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "description": "a webhook",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url",
        "title": "A title"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_non-JSON_body_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a non-JSON body for a consumer and provider** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": "<xml></xml>",
      "username": "username",
      "password": "password"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "description": "a webhook",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url",
        "title": "A title"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_every_possible_event_type_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with every possible event type** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      },
      {
        "name": "contract_published"
      },
      {
        "name": "provider_verification_published"
      },
      {
        "name": "provider_verification_succeeded"
      },
      {
        "name": "provider_verification_failed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "description": "a webhook",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url",
        "title": "A title"
      }
    }
  }
}
```
<a name="a_request_to_get_the_Pricing_Service_given_the_&#39;Pricing_Service&#39;_already_exists_in_the_pact-broker"></a>
Given **the 'Pricing Service' already exists in the pact-broker**, upon receiving **a request to get the Pricing Service** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacticipants/Pricing%20Service"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json"
  },
  "body": {
    "_links": {
      "self": {
        "href": "http://example.org/pacticipants/Pricing%20Service"
      },
      "versions": {
        "href": "http://example.org/pacticipants/Pricing%20Service/versions"
      }
    },
    "name": "Pricing Service",
    "repositoryUrl": "git@git.realestate.com.au:business-systems/pricing-service",
    "_embedded": {
      "latest-version": {
        "_links": {
          "self": {
            "href": "http://example.org/pacticipants/Pricing%20Service/versions/1.3.0"
          }
        },
        "number": "1.3.0"
      }
    }
  }
}
```
<a name="a_request_to_get_the_Pricing_Service_given_the_&#39;Pricing_Service&#39;_does_not_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' does not exist in the pact-broker**, upon receiving **a request to get the Pricing Service** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacticipants/Pricing%20Service"
}
```
Pact Broker will respond with:
```json
{
  "status": 404
}
```
<a name="a_request_to_list_pacticipants_given_&#39;Condor&#39;_exists_in_the_pact-broker"></a>
Given **'Condor' exists in the pact-broker**, upon receiving **a request to list pacticipants** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacticipants"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json"
  },
  "body": {
    "_links": {
      "self": {
        "href": "http://example.org/pacticipants"
      },
      "pacticipants": [
        {
          "href": "http://example.org/pacticipants/Condor",
          "title": "Condor"
        }
      ]
    },
    "pacticipants": [
      {
        "_links": {
          "self": {
            "href": "http://example.org/pacticipants/Condor"
          }
        },
        "name": "Condor",
        "_embedded": {
          "latest-version": {
            "_links": {
              "self": {
                "href": "http://example.org/pacticipants/Condor/versions/1.3.0"
              }
            },
            "number": "1.3.0"
          }
        }
      }
    ]
  }
}
```
<a name="a_request_to_list_the_latest_pacts_given_a_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **a pact between Condor and the Pricing Service exists**, upon receiving **a request to list the latest pacts** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacts/latest"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json"
  },
  "body": {
    "_links": {
      "self": {
        "href": "http://example.org/pacts/latest"
      }
    },
    "pacts": [
      {
        "_links": {
          "self": [
            {
              "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/latest"
            },
            {
              "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0"
            }
          ]
        },
        "_embedded": {
          "consumer": {
            "name": "Condor",
            "_links": {
              "self": {
                "href": "http://example.org/pacticipants/Condor"
              }
            },
            "_embedded": {
              "version": {
                "number": "1.3.0"
              }
            }
          },
          "provider": {
            "_links": {
              "self": {
                "href": "http://example.org/pacticipants/Pricing%20Service"
              }
            },
            "name": "Pricing Service"
          }
        }
      }
    ]
  }
}
```
<a name="a_request_to_publish_a_pact_given_&#39;Condor&#39;_already_exist_in_the_pact-broker,_but_the_&#39;Pricing_Service&#39;_does_not"></a>
Given **'Condor' already exist in the pact-broker, but the 'Pricing Service' does not**, upon receiving **a request to publish a pact** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "interactions": [

    ]
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:latest-pact-version": {
        "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/latest"
      }
    }
  }
}
```
<a name="a_request_to_publish_a_pact_given_the_&#39;Pricing_Service&#39;_already_exists_in_the_pact-broker"></a>
Given **the 'Pricing Service' already exists in the pact-broker**, upon receiving **a request to publish a pact** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "interactions": [

    ]
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:latest-pact-version": {
        "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/latest"
      }
    }
  }
}
```
<a name="a_request_to_publish_a_pact_given_an_error_occurs_while_publishing_a_pact"></a>
Given **an error occurs while publishing a pact**, upon receiving **a request to publish a pact** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "interactions": [

    ]
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 500,
  "headers": {
    "Content-Type": "application/hal+json"
  },
  "body": {
    "error": {
      "message": "An error occurred"
    }
  }
}
```
<a name="a_request_to_publish_a_pact_with_method_patch_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0**, upon receiving **a request to publish a pact with method patch** from Pact Broker Client, with
```json
{
  "method": "patch",
  "path": "/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "interactions": [

    ]
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:latest-pact-version": {
        "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/latest"
      }
    }
  }
}
```
<a name="a_request_to_publish_a_pact_with_method_put_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0**, upon receiving **a request to publish a pact with method put** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "interactions": [

    ]
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:latest-pact-version": {
        "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/latest"
      }
    }
  }
}
```
<a name="a_request_to_publish_contracts"></a>
Upon receiving **a request to publish contracts** from Pact Broker Client, with
```json
{
  "method": "POST",
  "path": "/HAL-REL-PLACEHOLDER-PB-PUBLISH-CONTRACTS",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "pacticipantName": "Foo",
    "pacticipantVersionNumber": "5556b8149bf8bac76bc30f50a8a2dd4c22c85f30",
    "branch": "main",
    "tags": [
      "dev"
    ],
    "buildUrl": "http://build",
    "contracts": [
      {
        "consumerName": "Foo",
        "providerName": "Bar",
        "specification": "pact",
        "contentType": "application/json",
        "content": "eyJjb25zdW1lciI6eyJuYW1lIjoiRm9vIn0sInByb3ZpZGVyIjp7Im5hbWUiOiJCYXIifSwiaW50ZXJhY3Rpb25zIjpbeyJkZXNjcmlwdGlvbiI6ImFuIGV4YW1wbGUgcmVxdWVzdCIsInByb3ZpZGVyU3RhdGUiOiJhIHByb3ZpZGVyIHN0YXRlIiwicmVxdWVzdCI6eyJtZXRob2QiOiJHRVQiLCJwYXRoIjoiLyIsImhlYWRlcnMiOnt9fSwicmVzcG9uc2UiOnsic3RhdHVzIjoyMDAsImhlYWRlcnMiOnsiQ29udGVudC1UeXBlIjoiYXBwbGljYXRpb24vaGFsK2pzb24ifX19XSwibWV0YWRhdGEiOnsicGFjdFNwZWNpZmljYXRpb24iOnsidmVyc2lvbiI6IjIuMC4wIn19fQ==",
        "writeMode": "overwrite",
        "onConflict": "overwrite"
      }
    ]
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_embedded": {
      "pacticipant": {
        "name": "Foo"
      },
      "version": {
        "number": "5556b8149bf8bac76bc30f50a8a2dd4c22c85f30",
        "buildUrl": "http://build"
      }
    },
    "logs": [
      {
        "level": "info",
        "message": "some message"
      }
    ],
    "_links": {
      "pb:pacticipant-version-tags": [
        {
          "name": "dev"
        }
      ],
      "pb:contracts": [
        {
          "href": "http://some-pact"
        }
      ]
    }
  }
}
```
<a name="a_request_to_register_the_repository_URL_of_a_pacticipant_given_the_&#39;Pricing_Service&#39;_already_exists_in_the_pact-broker"></a>
Given **the 'Pricing Service' already exists in the pact-broker**, upon receiving **a request to register the repository URL of a pacticipant** from Pact Broker Client, with
```json
{
  "method": "patch",
  "path": "/pacticipants/Pricing%20Service",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "repository_url": "git@git.realestate.com.au:business-systems/pricing-service"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  }
}
```
<a name="a_request_to_register_the_repository_URL_of_a_pacticipant_given_the_&#39;Pricing_Service&#39;_does_not_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' does not exist in the pact-broker**, upon receiving **a request to register the repository URL of a pacticipant** from Pact Broker Client, with
```json
{
  "method": "patch",
  "path": "/pacticipants/Pricing%20Service",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "repository_url": "git@git.realestate.com.au:business-systems/pricing-service"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  }
}
```
<a name="a_request_to_retrieve_a_pacticipant_given_a_pacticipant_with_name_Foo_exists"></a>
Given **a pacticipant with name Foo exists**, upon receiving **a request to retrieve a pacticipant** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacticipants/Foo",
  "headers": {
    "Accept": "application/hal+json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "self": {
        "href": "http://localhost:1234/pacticipants/Foo"
      }
    }
  }
}
```
<a name="a_request_to_retrieve_a_pacticipant"></a>
Upon receiving **a request to retrieve a pacticipant** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacticipants/Foo",
  "headers": {
    "Accept": "application/hal+json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 404
}
```
<a name="a_request_to_retrieve_the_latest_&#39;production&#39;_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker_with_the_latest_tagged_&#39;production&#39;_version_1.2.3"></a>
Given **'Condor' exists in the pact-broker with the latest tagged 'production' version 1.2.3**, upon receiving **a request to retrieve the latest 'production' version of Condor** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/HAL-REL-PLACEHOLDER-INDEX-PB-LATEST-TAGGED-VERSION-Condor-production",
  "headers": {
    "Accept": "application/hal+json, application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "number": "1.2.3",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url"
      }
    }
  }
}
```
<a name="a_request_to_retrieve_the_latest_pact_between_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **a pact between Condor and the Pricing Service exists**, upon receiving **a request to retrieve the latest pact between Condor and the Pricing Service** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacts/provider/Pricing%20Service/consumer/Condor/latest"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json",
    "X-Pact-Consumer-Version": "1.3.0"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "interactions": [

    ]
  }
}
```
<a name="a_request_to_retrieve_the_latest_pact_between_Condor_and_the_Pricing_Service_given_no_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **no pact between Condor and the Pricing Service exists**, upon receiving **a request to retrieve the latest pact between Condor and the Pricing Service** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacts/provider/Pricing%20Service/consumer/Condor/latest"
}
```
Pact Broker will respond with:
```json
{
  "status": 404
}
```
<a name="a_request_to_retrieve_the_latest_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker_with_the_latest_version_1.2.3"></a>
Given **'Condor' exists in the pact-broker with the latest version 1.2.3**, upon receiving **a request to retrieve the latest version of Condor** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/HAL-REL-PLACEHOLDER-INDEX-PB-LATEST-VERSION-Condor",
  "headers": {
    "Accept": "application/hal+json, application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "number": "1.2.3",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url"
      }
    }
  }
}
```
<a name="a_request_to_retrieve_the_pact_between_the_production_verison_of_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists_for_the_production_version_of_Condor"></a>
Given **a pact between Condor and the Pricing Service exists for the production version of Condor**, upon receiving **a request to retrieve the pact between the production verison of Condor and the Pricing Service** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacts/provider/Pricing%20Service/consumer/Condor/latest/prod",
  "headers": {
    "Accept": "application/hal+json, application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "interactions": [

    ]
  }
}
```
<a name="a_request_to_tag_the_production_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker_with_version_1.3.0,_tagged_with_&#39;prod&#39;"></a>
Given **'Condor' exists in the pact-broker with version 1.3.0, tagged with 'prod'**, upon receiving **a request to tag the production version of Condor** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pacticipants/Condor/versions/1.3.0/tags/prod",
  "headers": {
    "Content-Type": "application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "self": {
        "href": "http://localhost:1234/pacticipants/Condor/versions/1.3.0/tags/prod"
      }
    }
  }
}
```
<a name="a_request_to_tag_the_production_version_of_Condor_given_&#39;Condor&#39;_does_not_exist_in_the_pact-broker"></a>
Given **'Condor' does not exist in the pact-broker**, upon receiving **a request to tag the production version of Condor** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pacticipants/Condor/versions/1.3.0/tags/prod",
  "headers": {
    "Content-Type": "application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "self": {
        "href": "http://localhost:1234/pacticipants/Condor/versions/1.3.0/tags/prod"
      }
    }
  }
}
```
<a name="a_request_to_tag_the_production_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker"></a>
Given **'Condor' exists in the pact-broker**, upon receiving **a request to tag the production version of Condor** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pacticipants/Condor/versions/1.3.0/tags/prod",
  "headers": {
    "Content-Type": "application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "self": {
        "href": "http://localhost:1234/pacticipants/Condor/versions/1.3.0/tags/prod"
      }
    }
  }
}
```
<a name="a_request_to_update_a_pacticipant_given_a_pacticipant_with_name_Foo_exists"></a>
Given **a pacticipant with name Foo exists**, upon receiving **a request to update a pacticipant** from Pact Broker Client, with
```json
{
  "method": "patch",
  "path": "/pacticipants/Foo",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "name": "Foo",
    "repositoryUrl": "http://foo"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "name": "Foo",
    "repositoryUrl": "http://foo",
    "_links": {
      "self": {
        "href": "http://localhost:1234/pacticipants/Foo"
      }
    }
  }
}
```
<a name="a_request_to_update_a_webhook_given_a_webhook_with_the_uuid_696c5f93-1b7f-44bc-8d03-59440fcaa9a0_exists"></a>
Given **a webhook with the uuid 696c5f93-1b7f-44bc-8d03-59440fcaa9a0 exists**, upon receiving **a request to update a webhook** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/webhooks/696c5f93-1b7f-44bc-8d03-59440fcaa9a0",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    },
    "provider": {
      "name": "Pricing Service"
    },
    "consumer": {
      "name": "Condor"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "description": "a webhook",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url",
        "title": "A title"
      }
    }
  }
}
```
<a name="an_invalid_request_to_create_a_webhook_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **an invalid request to create a webhook for a consumer and provider** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": null,
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      },
      "username": "username",
      "password": "password"
    }
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 400,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "errors": {
      "request.url": [
        "Some error"
      ]
    }
  }
}
```
