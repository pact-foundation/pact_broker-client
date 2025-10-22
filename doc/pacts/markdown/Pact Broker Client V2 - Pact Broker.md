### A pact between Pact Broker Client V2 and Pact Broker

#### Requests from Pact Broker Client V2 to Pact Broker

* [A request for a pacticipant version](#a_request_for_a_pacticipant_version_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_2_environments_that_aren&#39;t_test_available_for_deployment) given version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with 2 environments that aren't test available for deployment

* [A request for a pacticipant version](#a_request_for_a_pacticipant_version_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_a_test_environment_available_for_deployment) given version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment

* [A request for a pacticipant version](#a_request_for_a_pacticipant_version_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_a_test_environment_available_for_release) given version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for release

* [A request for an environment](#a_request_for_an_environment_given_an_environment_with_name_test_and_UUID_16926ef3-590f-4e3f-838e-719717aa88c9_exists) given an environment with name test and UUID 16926ef3-590f-4e3f-838e-719717aa88c9 exists

* [A request for the compatibility matrix for a pacticipant that does not exist](#a_request_for_the_compatibility_matrix_for_a_pacticipant_that_does_not_exist)

* [A request for the compatibility matrix for all versions of Foo and Bar](#a_request_for_the_compatibility_matrix_for_all_versions_of_Foo_and_Bar_given_the_pact_for_Foo_version_1.2.3_and_1.2.4_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 and 1.2.4 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_Thing_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo Thing version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix for Foo version 1.2.3 and the latest prod version of Bar](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_version_of_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_with_tag_prod,_and_1.2.4_unsuccessfully_by_9.9.9) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 with tag prod, and 1.2.4 unsuccessfully by 9.9.9

* [A request for the compatibility matrix for Foo version 1.2.3 and the latest prod versions of all other pacticipants](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_versions_of_all_other_pacticipants_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_(tagged_prod)_and_version_5.6.7) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 (tagged prod) and version 5.6.7

* [A request for the compatibility matrix for Foo version 1.2.3 and the latest version of Bar](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_version_of_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6,_and_1.2.4_unsuccessfully_by_9.9.9) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9

* [A request for the compatibility matrix where one or more versions does not exist](#a_request_for_the_compatibility_matrix_where_one_or_more_versions_does_not_exist_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix where only the version of Foo is specified](#a_request_for_the_compatibility_matrix_where_only_the_version_of_Foo_is_specified_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6_and_version_5.6.7) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6 and version 5.6.7

* [A request for the environments](#a_request_for_the_environments_given_an_environment_with_name_test_exists) given an environment with name test exists

* [A request for the index resource](#a_request_for_the_index_resource)

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pacticipant_relations_are_present) given the pacticipant relations are present

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:environments_relation_exists_in_the_index_resource) given the pb:environments relation exists in the index resource

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:latest-tagged-version_relation_exists_in_the_index_resource) given the pb:latest-tagged-version relation exists in the index resource

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:latest-version_relation_exists_in_the_index_resource) given the pb:latest-version relation exists in the index resource

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:pacticipant-branch_relation_exists_in_the_index_resource) given the pb:pacticipant-branch relation exists in the index resource

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:pacticipant-version_and_pb:environments_relations_exist_in_the_index_resource) given the pb:pacticipant-version and pb:environments relations exist in the index resource

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:publish-contracts_relations_exists_in_the_index_resource) given the pb:publish-contracts relations exists in the index resource

* [A request for the index resource with the webhook relation](#a_request_for_the_index_resource_with_the_webhook_relation)

* [A request for the list of the latest pacts from all consumers for the Pricing Service'](#a_request_for_the_list_of_the_latest_pacts_from_all_consumers_for_the_Pricing_Service&#39;_given_a_latest_pact_between_Condor_and_the_Pricing_Service_exists) given a latest pact between Condor and the Pricing Service exists

* [A request for the list of the latest prod pacts from all consumers for the Pricing Service'](#a_request_for_the_list_of_the_latest_prod_pacts_from_all_consumers_for_the_Pricing_Service&#39;_given_tagged_as_prod_pact_between_Condor_and_the_Pricing_Service_exists) given tagged as prod pact between Condor and the Pricing Service exists

* [A request for the successful rows of the compatibility matrix for all versions of Foo and Bar](#a_request_for_the_successful_rows_of_the_compatibility_matrix_for_all_versions_of_Foo_and_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6,_and_1.2.4_unsuccessfully_by_9.9.9) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9

* [A request retrieve a pact for a specific version](#a_request_retrieve_a_pact_for_a_specific_version_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0) given the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0

* [A request to create a global webhook with a JSON body](#a_request_to_create_a_global_webhook_with_a_JSON_body)

* [A request to create a pacticipant](#a_request_to_create_a_pacticipant)

* [A request to create a webhook for a consumer and provider](#a_request_to_create_a_webhook_for_a_consumer_and_provider_given_&#39;Condor&#39;_does_not_exist_in_the_pact-broker) given 'Condor' does not exist in the pact-broker

* [A request to create a webhook with a JSON body and a uuid](#a_request_to_create_a_webhook_with_a_JSON_body_and_a_uuid_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with a JSON body for a consumer](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with a JSON body for a consumer and provider](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with a JSON body for a consumer specified by a label](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_specified_by_a_label)

* [A request to create a webhook with a JSON body for a consumer that does not exist](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_that_does_not_exist)

* [A request to create a webhook with a JSON body for a provider](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with a JSON body for a provider specified by a label](#a_request_to_create_a_webhook_with_a_JSON_body_for_a_provider_specified_by_a_label)

* [A request to create a webhook with a non-JSON body for a consumer and provider](#a_request_to_create_a_webhook_with_a_non-JSON_body_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create a webhook with every possible event type](#a_request_to_create_a_webhook_with_every_possible_event_type_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker) given the 'Pricing Service' and 'Condor' already exist in the pact-broker

* [A request to create an environment](#a_request_to_create_an_environment)

* [A request to delete a pacticipant branch](#a_request_to_delete_a_pacticipant_branch_given_a_branch_named_main_exists_for_pacticipant_Foo) given a branch named main exists for pacticipant Foo

* [A request to determine if Bar can be deployed with all Foo tagged prod, ignoring the verification for Foo version 3.4.5](#a_request_to_determine_if_Bar_can_be_deployed_with_all_Foo_tagged_prod,_ignoring_the_verification_for_Foo_version_3.4.5_given_provider_Bar_version_4.5.6_has_a_successful_verification_for_Foo_version_1.2.3_tagged_prod_and_a_failed_verification_for_version_3.4.5_tagged_prod) given provider Bar version 4.5.6 has a successful verification for Foo version 1.2.3 tagged prod and a failed verification for version 3.4.5 tagged prod

* [A request to get the Pricing Service](#a_request_to_get_the_Pricing_Service_given_the_&#39;Pricing_Service&#39;_already_exists_in_the_pact-broker) given the 'Pricing Service' already exists in the pact-broker

* [A request to get the Pricing Service](#a_request_to_get_the_Pricing_Service_given_the_&#39;Pricing_Service&#39;_does_not_exist_in_the_pact-broker) given the 'Pricing Service' does not exist in the pact-broker

* [A request to list pacticipants](#a_request_to_list_pacticipants_given_&#39;Condor&#39;_exists_in_the_pact-broker) given 'Condor' exists in the pact-broker

* [A request to list the environments](#a_request_to_list_the_environments_given_an_environment_exists) given an environment exists

* [A request to list the latest pacts](#a_request_to_list_the_latest_pacts_given_a_pact_between_Condor_and_the_Pricing_Service_exists) given a pact between Condor and the Pricing Service exists

* [A request to list the versions deployed to an environment for a pacticipant name and application instance](#a_request_to_list_the_versions_deployed_to_an_environment_for_a_pacticipant_name_and_application_instance_given_an_version_is_deployed_to_environment_with_UUID_16926ef3-590f-4e3f-838e-719717aa88c9_with_target_customer-1) given an version is deployed to environment with UUID 16926ef3-590f-4e3f-838e-719717aa88c9 with target customer-1

* [A request to mark a deployed version as not currently deploye](#a_request_to_mark_a_deployed_version_as_not_currently_deploye_given_a_currently_deployed_version_exists) given a currently deployed version exists

* [A request to publish contracts](#a_request_to_publish_contracts)

* [A request to record a deployment](#a_request_to_record_a_deployment_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_a_test_environment_available_for_deployment) given version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment

* [A request to record a release](#a_request_to_record_a_release_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_a_test_environment_available_for_deployment) given version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment

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

<a name="a_request_for_a_pacticipant_version_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_2_environments_that_aren&#39;t_test_available_for_deployment"></a>
Given **version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with 2 environments that aren't test available for deployment**, upon receiving **a request for a pacticipant version** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/pacticipants/Foo/versions/5556b8149bf8bac76bc30f50a8a2dd4c22c85f30",
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
      "pb:record-deployment": [
        {
          "href": "href",
          "name": "prod"
        },
        {
          "href": "href",
          "name": "dev"
        }
      ]
    }
  }
}
```
<a name="a_request_for_a_pacticipant_version_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_a_test_environment_available_for_deployment"></a>
Given **version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment**, upon receiving **a request for a pacticipant version** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/pacticipants/Foo/versions/5556b8149bf8bac76bc30f50a8a2dd4c22c85f30",
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
      "pb:record-deployment": [
        {
          "href": "/pacticipants/Foo/versions/5556b8149bf8bac76bc30f50a8a2dd4c22c85f30/deployed-versions/environment/cb632df3-0a0d-4227-aac3-60114dd36479",
          "name": "test"
        }
      ]
    }
  }
}
```
<a name="a_request_for_a_pacticipant_version_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_a_test_environment_available_for_release"></a>
Given **version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for release**, upon receiving **a request for a pacticipant version** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/pacticipants/Foo/versions/5556b8149bf8bac76bc30f50a8a2dd4c22c85f30",
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
      "pb:record-release": [
        {
          "href": "/pacticipants/Foo/versions/5556b8149bf8bac76bc30f50a8a2dd4c22c85f30/released-versions/environment/cb632df3-0a0d-4227-aac3-60114dd36479",
          "name": "test"
        }
      ]
    }
  }
}
```
<a name="a_request_for_an_environment_given_an_environment_with_name_test_and_UUID_16926ef3-590f-4e3f-838e-719717aa88c9_exists"></a>
Given **an environment with name test and UUID 16926ef3-590f-4e3f-838e-719717aa88c9 exists**, upon receiving **a request for an environment** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/environments/16926ef3-590f-4e3f-838e-719717aa88c9",
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
      "pb:currently-deployed-deployed-versions": {
        "href": "/environments/16926ef3-590f-4e3f-838e-719717aa88c9/deployed-versions/currently-deployed"
      }
    }
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_a_pacticipant_that_does_not_exist"></a>
Upon receiving **a request for the compatibility matrix for a pacticipant that does not exist** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latestby=cvpv&q[][pacticipant]=Wiffle&q[][pacticipant]=Meep&q[][version]=1%2e2%2e3&q[][version]=9%2e9%2e9"
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
Given **the pact for Foo version 1.2.3 and 1.2.4 has been verified by Bar version 4.5.6**, upon receiving **a request for the compatibility matrix for all versions of Foo and Bar** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latestby=cvpv&q[][pacticipant]=Foo&q[][pacticipant]=Bar"
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
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": true,
          "verifiedAt": "2017-10-10T12:49:04+11:00"
        }
      },
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "4"
          }
        },
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": true,
          "verifiedAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ]
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_Thing_version_1.2.3_has_been_verified_by_Bar_version_4.5.6"></a>
Given **the pact for Foo Thing version 1.2.3 has been verified by Bar version 4.5.6**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latestby=cvpv&q[][pacticipant]=Foo+Thing&q[][pacticipant]=Bar&q[][version]=1%2e2%2e3&q[][version]=4%2e5%2e6"
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
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": true,
          "verifiedAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ],
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    }
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6"></a>
Given **the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latestby=cvpv&q[][pacticipant]=Foo&q[][pacticipant]=Bar&q[][version]=1%2e2%2e3&q[][version]=4%2e5%2e6"
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
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": true,
          "verifiedAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ],
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    }
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_version_of_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_with_tag_prod,_and_1.2.4_unsuccessfully_by_9.9.9"></a>
Given **the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 with tag prod, and 1.2.4 unsuccessfully by 9.9.9**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and the latest prod version of Bar** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latestby=cvpv&q[][latest]=true&q[][pacticipant]=Foo&q[][pacticipant]=Bar&q[][tag]=prod&q[][version]=1%2e2%2e3"
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
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": true,
          "verifiedAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ],
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    }
  }
}
```
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_versions_of_all_other_pacticipants_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_(tagged_prod)_and_version_5.6.7"></a>
Given **the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 (tagged prod) and version 5.6.7**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and the latest prod versions of all other pacticipants** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latest=true&latestby=cvp&q[][pacticipant]=Foo&q[][version]=1%2e2%2e3&tag=prod"
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
Given **the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 and the latest version of Bar** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latestby=cvpv&q[][latest]=true&q[][pacticipant]=Foo&q[][pacticipant]=Bar&q[][version]=1%2e2%2e4"
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
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": true,
          "verifiedAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ],
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    }
  }
}
```
<a name="a_request_for_the_compatibility_matrix_where_one_or_more_versions_does_not_exist_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6"></a>
Given **the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6**, upon receiving **a request for the compatibility matrix where one or more versions does not exist** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latestby=cvpv&q[][pacticipant]=Foo&q[][pacticipant]=Bar&q[][version]=1%2e2%2e3&q[][version]=9%2e9%2e9"
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
Given **the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6 and version 5.6.7**, upon receiving **a request for the compatibility matrix where only the version of Foo is specified** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latest=true&latestby=cvp&q[][pacticipant]=Foo&q[][version]=1%2e2%2e3"
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
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": true,
          "verifiedAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ],
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    }
  }
}
```
<a name="a_request_for_the_environments_given_an_environment_with_name_test_exists"></a>
Given **an environment with name test exists**, upon receiving **a request for the environments** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/environments",
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
      "pb:environments": [
        {
          "href": "href",
          "name": "test"
        }
      ]
    }
  }
}
```
<a name="a_request_for_the_index_resource"></a>
Upon receiving **a request for the index resource** from Pact Broker Client V2, with
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
      "pb:pacticipant": {
        "href": "/pacticipants/{pacticipant}"
      },
      "pb:pacticipants": {
        "href": "/pacticipants"
      },
      "pb:webhooks": {
        "href": "/webhooks"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pacticipant_relations_are_present"></a>
Given **the pacticipant relations are present**, upon receiving **a request for the index resource** from Pact Broker Client V2, with
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
      "pb:pacticipant": {
        "href": "/pacticipants/{pacticipant}"
      },
      "pb:pacticipants": {
        "href": "/pacticipants"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:environments_relation_exists_in_the_index_resource"></a>
Given **the pb:environments relation exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client V2, with
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
      "pb:environments": {
        "href": "/environments"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:latest-tagged-version_relation_exists_in_the_index_resource"></a>
Given **the pb:latest-tagged-version relation exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
        "href": "http://127.0.0.1:9999/pacticipants/Condor/latest-version/production"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:latest-version_relation_exists_in_the_index_resource"></a>
Given **the pb:latest-version relation exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
        "href": "http://127.0.0.1:9999/pacticipants/Condor/latest-version"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:pacticipant-branch_relation_exists_in_the_index_resource"></a>
Given **the pb:pacticipant-branch relation exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client V2, with
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
      "pb:pacticipant-branch": {
        "href": "/pacticipants/{pacticipant}/branches/{branch}"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:pacticipant-version_and_pb:environments_relations_exist_in_the_index_resource"></a>
Given **the pb:pacticipant-version and pb:environments relations exist in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client V2, with
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
      "pb:environments": {
        "href": "/environments"
      },
      "pb:pacticipant-version": {
        "href": "/pacticipants/{pacticipant}/versions/{version}"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:publish-contracts_relations_exists_in_the_index_resource"></a>
Given **the pb:publish-contracts relations exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client V2, with
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
        "href": "/contracts/publish"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_with_the_webhook_relation"></a>
Upon receiving **a request for the index resource with the webhook relation** from Pact Broker Client V2, with
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
      "pb:webhook": {
        "href": "/webhooks/{uuid}",
        "templated": true
      }
    }
  }
}
```
<a name="a_request_for_the_list_of_the_latest_pacts_from_all_consumers_for_the_Pricing_Service&#39;_given_a_latest_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **a latest pact between Condor and the Pricing Service exists**, upon receiving **a request for the list of the latest pacts from all consumers for the Pricing Service'** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/pacts/provider/Pricing%20Service/latest"
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
      "pb:pacts": [
        {
          "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
          "name": "Condor",
          "title": "Pact between Condor (v1.3.0) and Pricing Service"
        }
      ],
      "provider": {
        "href": "http://example.org/pacticipants/Pricing%20Service",
        "title": "Pricing Service"
      }
    }
  }
}
```
<a name="a_request_for_the_list_of_the_latest_prod_pacts_from_all_consumers_for_the_Pricing_Service&#39;_given_tagged_as_prod_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **tagged as prod pact between Condor and the Pricing Service exists**, upon receiving **a request for the list of the latest prod pacts from all consumers for the Pricing Service'** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/pacts/provider/Pricing%20Service/latest/prod"
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
      "pb:pacts": [
        {
          "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
          "name": "Condor",
          "title": "Pact between Condor (v1.3.0) and Pricing Service"
        }
      ],
      "provider": {
        "href": "http://example.org/pacticipants/Pricing%20Service",
        "title": "Pricing Service"
      }
    }
  }
}
```
<a name="a_request_for_the_successful_rows_of_the_compatibility_matrix_for_all_versions_of_Foo_and_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6,_and_1.2.4_unsuccessfully_by_9.9.9"></a>
Given **the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9**, upon receiving **a request for the successful rows of the compatibility matrix for all versions of Foo and Bar** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "latestby=cvpv&q[][pacticipant]=Foo&q[][pacticipant]=Bar&success[]=true"
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
        "pact": {
          "createdAt": "2017-10-10T12:49:04+11:00"
        },
        "provider": {
          "name": "Bar",
          "version": {
            "number": "5"
          }
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": true,
          "verifiedAt": "2017-10-10T12:49:04+11:00"
        }
      }
    ],
    "summary": {
      "deployable": true,
      "reason": "some text",
      "unknown": 1
    }
  }
}
```
<a name="a_request_retrieve_a_pact_for_a_specific_version_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0**, upon receiving **a request retrieve a pact for a specific version** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
    "interactions": [
        ],
    "provider": {
      "name": "Pricing Service"
    }
  }
}
```
<a name="a_request_to_create_a_global_webhook_with_a_JSON_body"></a>
Upon receiving **a request to create a global webhook with a JSON body** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      }
    }
  }
}
```
<a name="a_request_to_create_a_pacticipant"></a>
Upon receiving **a request to create a pacticipant** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/pacticipants",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
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
    "_links": {
      "self": {
        "href": "/pacticipants/Foo"
      }
    },
    "name": "Foo",
    "repositoryUrl": "http://foo"
  }
}
```
<a name="a_request_to_create_a_webhook_for_a_consumer_and_provider_given_&#39;Condor&#39;_does_not_exist_in_the_pact-broker"></a>
Given **'Condor' does not exist in the pact-broker**, upon receiving **a request to create a webhook for a consumer and provider** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a JSON body and a uuid** from Pact Broker Client V2, with
```json
{
  "method": "PUT",
  "path": "/webhooks/696c5f93-1b7f-44bc-8d03-59440fcaa9a0",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "provider": {
      "name": "Pricing Service"
    },
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a JSON body for a consumer** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a JSON body for a consumer and provider** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_specified_by_a_label"></a>
Upon receiving **a request to create a webhook with a JSON body for a consumer specified by a label** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "label": "consumer_label"
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_for_a_consumer_that_does_not_exist"></a>
Upon receiving **a request to create a webhook with a JSON body for a consumer that does not exist** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a JSON body for a provider** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "provider": {
      "name": "Pricing Service"
    },
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_JSON_body_for_a_provider_specified_by_a_label"></a>
Upon receiving **a request to create a webhook with a JSON body for a provider specified by a label** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "provider": {
      "label": "provider_label"
    },
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_a_non-JSON_body_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with a non-JSON body for a consumer and provider** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": "<xml></xml>",
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": "<xml></xml>"
    }
  }
}
```
<a name="a_request_to_create_a_webhook_with_every_possible_event_type_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **a request to create a webhook with every possible event type** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
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
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
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
      "body": {
        "some": "body"
      }
    }
  }
}
```
<a name="a_request_to_create_an_environment"></a>
Upon receiving **a request to create an environment** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/environments",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "contacts": [
      {
        "details": {
          "emailAddress": "foo@bar.com"
        },
        "name": "Foo team"
      }
    ],
    "displayName": "Test",
    "name": "test",
    "production": false
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
    "contacts": [
      {
        "details": {
          "emailAddress": "foo@bar.com"
        },
        "name": "Foo team"
      }
    ],
    "displayName": "Test",
    "name": "test",
    "production": false,
    "uuid": "ffe683ef-dcd7-4e4f-877d-f6eb3db8e86e"
  }
}
```
<a name="a_request_to_delete_a_pacticipant_branch_given_a_branch_named_main_exists_for_pacticipant_Foo"></a>
Given **a branch named main exists for pacticipant Foo**, upon receiving **a request to delete a pacticipant branch** from Pact Broker Client V2, with
```json
{
  "method": "DELETE",
  "path": "/pacticipants/Foo/branches/main"
}
```
Pact Broker will respond with:
```json
{
  "status": 204
}
```
<a name="a_request_to_determine_if_Bar_can_be_deployed_with_all_Foo_tagged_prod,_ignoring_the_verification_for_Foo_version_3.4.5_given_provider_Bar_version_4.5.6_has_a_successful_verification_for_Foo_version_1.2.3_tagged_prod_and_a_failed_verification_for_version_3.4.5_tagged_prod"></a>
Given **provider Bar version 4.5.6 has a successful verification for Foo version 1.2.3 tagged prod and a failed verification for version 3.4.5 tagged prod**, upon receiving **a request to determine if Bar can be deployed with all Foo tagged prod, ignoring the verification for Foo version 3.4.5** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/matrix",
  "query": "ignore[][pacticipant]=Foo&ignore[][version]=3%2e4%2e5&latestby=cvpv&q[][pacticipant]=Bar&q[][pacticipant]=Foo&q[][tag]=prod&q[][version]=4%2e5%2e6"
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
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": true
        }
      },
      {
        "consumer": {
          "name": "Foo",
          "version": {
            "number": "3.4.5"
          }
        },
        "ignored": true,
        "provider": {
          "name": "Bar",
          "version": {
            "number": "4.5.6"
          }
        },
        "verificationResult": {
          "_links": {
            "self": {
              "href": "http://result"
            }
          },
          "success": false
        }
      }
    ],
    "notices": [
      {
        "text": "some notice",
        "type": "info"
      }
    ],
    "summary": {
      "deployable": true,
      "ignored": 1
    }
  }
}
```
<a name="a_request_to_get_the_Pricing_Service_given_the_&#39;Pricing_Service&#39;_already_exists_in_the_pact-broker"></a>
Given **the 'Pricing Service' already exists in the pact-broker**, upon receiving **a request to get the Pricing Service** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
    "_embedded": {
      "latest-version": {
        "_links": {
          "self": {
            "href": "http://example.org/pacticipants/Pricing%20Service/versions/1.3.0"
          }
        },
        "number": "1.3.0"
      }
    },
    "_links": {
      "self": {
        "href": "http://example.org/pacticipants/Pricing%20Service"
      },
      "versions": {
        "href": "http://example.org/pacticipants/Pricing%20Service/versions"
      }
    },
    "name": "Pricing Service",
    "repositoryUrl": "git@git.realestate.com.au:business-systems/pricing-service"
  }
}
```
<a name="a_request_to_get_the_Pricing_Service_given_the_&#39;Pricing_Service&#39;_does_not_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' does not exist in the pact-broker**, upon receiving **a request to get the Pricing Service** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
Given **'Condor' exists in the pact-broker**, upon receiving **a request to list pacticipants** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
      "pacticipants": [
        {
          "href": "http://example.org/pacticipants/Condor",
          "title": "Condor"
        }
      ],
      "self": {
        "href": "http://example.org/pacticipants"
      }
    },
    "pacticipants": [
      {
        "_embedded": {
          "latest-version": {
            "_links": {
              "self": {
                "href": "http://example.org/pacticipants/Condor/versions/1.3.0"
              }
            },
            "number": "1.3.0"
          }
        },
        "_links": {
          "self": {
            "href": "http://example.org/pacticipants/Condor"
          }
        },
        "name": "Condor"
      }
    ]
  }
}
```
<a name="a_request_to_list_the_environments_given_an_environment_exists"></a>
Given **an environment exists**, upon receiving **a request to list the environments** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/environments",
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
    "_embedded": {
      "environments": [
        {
          "contacts": [
            {
              "details": {
                "emailAddress": "foo@bar.com"
              },
              "name": "Foo team"
            }
          ],
          "displayName": "Test",
          "name": "test",
          "production": false,
          "uuid": "78e85fb2-9df1-48da-817e-c9bea6294e01"
        }
      ]
    }
  }
}
```
<a name="a_request_to_list_the_latest_pacts_given_a_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **a pact between Condor and the Pricing Service exists**, upon receiving **a request to list the latest pacts** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
        "_embedded": {
          "consumer": {
            "_embedded": {
              "version": {
                "number": "1.3.0"
              }
            },
            "_links": {
              "self": {
                "href": "http://example.org/pacticipants/Condor"
              }
            },
            "name": "Condor"
          },
          "provider": {
            "_links": {
              "self": {
                "href": "http://example.org/pacticipants/Pricing%20Service"
              }
            },
            "name": "Pricing Service"
          }
        },
        "_links": {
          "self": [
            {
              "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/latest"
            },
            {
              "href": "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0"
            }
          ]
        }
      }
    ]
  }
}
```
<a name="a_request_to_list_the_versions_deployed_to_an_environment_for_a_pacticipant_name_and_application_instance_given_an_version_is_deployed_to_environment_with_UUID_16926ef3-590f-4e3f-838e-719717aa88c9_with_target_customer-1"></a>
Given **an version is deployed to environment with UUID 16926ef3-590f-4e3f-838e-719717aa88c9 with target customer-1**, upon receiving **a request to list the versions deployed to an environment for a pacticipant name and application instance** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/environments/16926ef3-590f-4e3f-838e-719717aa88c9/deployed-versions/currently-deployed",
  "query": "pacticipant=Foo",
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
    "_embedded": {
      "deployedVersions": [
        {
          "_links": {
            "self": {
              "href": "/deployed-versions/ff3adecf-cfc5-4653-a4e3-f1861092f8e0"
            }
          },
          "applicationInstance": "customer-1"
        }
      ]
    }
  }
}
```
<a name="a_request_to_mark_a_deployed_version_as_not_currently_deploye_given_a_currently_deployed_version_exists"></a>
Given **a currently deployed version exists**, upon receiving **a request to mark a deployed version as not currently deploye** from Pact Broker Client V2, with
```json
{
  "method": "PATCH",
  "path": "/deployed-versions/ff3adecf-cfc5-4653-a4e3-f1861092f8e0",
  "headers": {
    "Content-Type": "application/merge-patch+json"
  },
  "body": {
    "currentlyDeployed": false
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
      "version": {
        "number": "2"
      }
    },
    "currentlyDeployed": false
  }
}
```
<a name="a_request_to_publish_contracts"></a>
Upon receiving **a request to publish contracts** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/contracts/publish",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "branch": "main",
    "buildUrl": "http://build",
    "contracts": [
      {
        "consumerName": "Foo",
        "content": "eyJjb25zdW1lciI6eyJuYW1lIjoiRm9vIn0sInByb3ZpZGVyIjp7Im5hbWUiOiJCYXIifSwiaW50ZXJhY3Rpb25zIjpbeyJkZXNjcmlwdGlvbiI6ImFuIGV4YW1wbGUgcmVxdWVzdCIsInByb3ZpZGVyU3RhdGUiOiJhIHByb3ZpZGVyIHN0YXRlIiwicmVxdWVzdCI6eyJtZXRob2QiOiJHRVQiLCJwYXRoIjoiLyIsImhlYWRlcnMiOnt9fSwicmVzcG9uc2UiOnsic3RhdHVzIjoyMDAsImhlYWRlcnMiOnsiQ29udGVudC1UeXBlIjoiYXBwbGljYXRpb24vaGFsK2pzb24ifX19XSwibWV0YWRhdGEiOnsicGFjdFNwZWNpZmljYXRpb24iOnsidmVyc2lvbiI6IjIuMC4wIn19fQ==",
        "contentType": "application/json",
        "onConflict": "merge",
        "providerName": "Bar",
        "specification": "pact"
      }
    ],
    "pacticipantName": "Foo",
    "pacticipantVersionNumber": "5556b8149bf8bac76bc30f50a8a2dd4c22c85f30",
    "tags": [
      "dev"
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
        "number": "5556b8149bf8bac76bc30f50a8a2dd4c22c85f30"
      }
    },
    "_links": {
      "pb:contracts": [
        {
          "href": "http://some-pact"
        }
      ],
      "pb:pacticipant-version-tags": [
        {
          "name": "dev"
        }
      ]
    },
    "logs": [
      {
        "level": "info",
        "message": "some message"
      }
    ]
  }
}
```
<a name="a_request_to_record_a_deployment_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_a_test_environment_available_for_deployment"></a>
Given **version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment**, upon receiving **a request to record a deployment** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/pacticipants/Foo/versions/5556b8149bf8bac76bc30f50a8a2dd4c22c85f30/deployed-versions/environment/cb632df3-0a0d-4227-aac3-60114dd36479",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "applicationInstance": "blue",
    "target": "blue"
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
    "target": "blue"
  }
}
```
<a name="a_request_to_record_a_release_given_version_5556b8149bf8bac76bc30f50a8a2dd4c22c85f30_of_pacticipant_Foo_exists_with_a_test_environment_available_for_deployment"></a>
Given **version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment**, upon receiving **a request to record a release** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/pacticipants/Foo/versions/5556b8149bf8bac76bc30f50a8a2dd4c22c85f30/released-versions/environment/cb632df3-0a0d-4227-aac3-60114dd36479",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
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
<a name="a_request_to_register_the_repository_URL_of_a_pacticipant_given_the_&#39;Pricing_Service&#39;_already_exists_in_the_pact-broker"></a>
Given **the 'Pricing Service' already exists in the pact-broker**, upon receiving **a request to register the repository URL of a pacticipant** from Pact Broker Client V2, with
```json
{
  "method": "PATCH",
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
Given **the 'Pricing Service' does not exist in the pact-broker**, upon receiving **a request to register the repository URL of a pacticipant** from Pact Broker Client V2, with
```json
{
  "method": "PATCH",
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
Given **a pacticipant with name Foo exists**, upon receiving **a request to retrieve a pacticipant** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
        "href": "/pacticipants/Foo"
      }
    }
  }
}
```
<a name="a_request_to_retrieve_a_pacticipant"></a>
Upon receiving **a request to retrieve a pacticipant** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
Given **'Condor' exists in the pact-broker with the latest tagged 'production' version 1.2.3**, upon receiving **a request to retrieve the latest 'production' version of Condor** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/pacticipants/Condor/latest-version/production",
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
      "self": {
        "href": "/some-url"
      }
    },
    "number": "1.2.3"
  }
}
```
<a name="a_request_to_retrieve_the_latest_pact_between_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **a pact between Condor and the Pricing Service exists**, upon receiving **a request to retrieve the latest pact between Condor and the Pricing Service** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
    "interactions": [
        ],
    "provider": {
      "name": "Pricing Service"
    }
  }
}
```
<a name="a_request_to_retrieve_the_latest_pact_between_Condor_and_the_Pricing_Service_given_no_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **no pact between Condor and the Pricing Service exists**, upon receiving **a request to retrieve the latest pact between Condor and the Pricing Service** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
Given **'Condor' exists in the pact-broker with the latest version 1.2.3**, upon receiving **a request to retrieve the latest version of Condor** from Pact Broker Client V2, with
```json
{
  "method": "GET",
  "path": "/pacticipants/Condor/latest-version",
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
      "self": {
        "href": "/some-url"
      }
    },
    "number": "1.2.3"
  }
}
```
<a name="a_request_to_retrieve_the_pact_between_the_production_verison_of_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists_for_the_production_version_of_Condor"></a>
Given **a pact between Condor and the Pricing Service exists for the production version of Condor**, upon receiving **a request to retrieve the pact between the production verison of Condor and the Pricing Service** from Pact Broker Client V2, with
```json
{
  "method": "GET",
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
    "interactions": [
        ],
    "provider": {
      "name": "Pricing Service"
    }
  }
}
```
<a name="a_request_to_tag_the_production_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker_with_version_1.3.0,_tagged_with_&#39;prod&#39;"></a>
Given **'Condor' exists in the pact-broker with version 1.3.0, tagged with 'prod'**, upon receiving **a request to tag the production version of Condor** from Pact Broker Client V2, with
```json
{
  "method": "PUT",
  "path": "/pacticipants/Condor/versions/1.3.0/tags/prod",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
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
        "href": "/pacticipants/Condor/versions/1.3.0/tags/prod"
      }
    }
  }
}
```
<a name="a_request_to_tag_the_production_version_of_Condor_given_&#39;Condor&#39;_does_not_exist_in_the_pact-broker"></a>
Given **'Condor' does not exist in the pact-broker**, upon receiving **a request to tag the production version of Condor** from Pact Broker Client V2, with
```json
{
  "method": "PUT",
  "path": "/pacticipants/Condor/versions/1.3.0/tags/prod",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
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
        "href": "/pacticipants/Condor/versions/1.3.0/tags/prod"
      }
    }
  }
}
```
<a name="a_request_to_tag_the_production_version_of_Condor_given_&#39;Condor&#39;_exists_in_the_pact-broker"></a>
Given **'Condor' exists in the pact-broker**, upon receiving **a request to tag the production version of Condor** from Pact Broker Client V2, with
```json
{
  "method": "PUT",
  "path": "/pacticipants/Condor/versions/1.3.0/tags/prod",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
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
        "href": "/pacticipants/Condor/versions/1.3.0/tags/prod"
      }
    }
  }
}
```
<a name="a_request_to_update_a_pacticipant_given_a_pacticipant_with_name_Foo_exists"></a>
Given **a pacticipant with name Foo exists**, upon receiving **a request to update a pacticipant** from Pact Broker Client V2, with
```json
{
  "method": "PATCH",
  "path": "/pacticipants/Foo",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
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
    "_links": {
      "self": {
        "href": "/pacticipants/Foo"
      }
    },
    "name": "Foo",
    "repositoryUrl": "http://foo"
  }
}
```
<a name="a_request_to_update_a_webhook_given_a_webhook_with_the_uuid_696c5f93-1b7f-44bc-8d03-59440fcaa9a0_exists"></a>
Given **a webhook with the uuid 696c5f93-1b7f-44bc-8d03-59440fcaa9a0 exists**, upon receiving **a request to update a webhook** from Pact Broker Client V2, with
```json
{
  "method": "PUT",
  "path": "/webhooks/696c5f93-1b7f-44bc-8d03-59440fcaa9a0",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "consumer": {
      "name": "Condor"
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "provider": {
      "name": "Pricing Service"
    },
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "url": "https://webhook",
      "username": "username"
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
    "_links": {
      "self": {
        "href": "/some-url"
      }
    },
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      }
    }
  }
}
```
<a name="an_invalid_request_to_create_a_webhook_for_a_consumer_and_provider_given_the_&#39;Pricing_Service&#39;_and_&#39;Condor&#39;_already_exist_in_the_pact-broker"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker**, upon receiving **an invalid request to create a webhook for a consumer and provider** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/webhooks/provider/Pricing%20Service/consumer/Condor",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "body": {
        "some": "body"
      },
      "headers": {
        "Bar": "foo",
        "Foo": "bar"
      },
      "method": "POST",
      "password": "password",
      "username": "username"
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
