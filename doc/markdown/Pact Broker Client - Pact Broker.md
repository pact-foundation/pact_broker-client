### A pact between Pact Broker Client and Pact Broker

#### Requests from Pact Broker Client to Pact Broker

* [A request for the latest version](#a_request_for_the_latest_version_given_no_version_exists_for_the_Pricing_Service) given no version exists for the Pricing Service

* [A request for the latest version tagged with 'prod'](#a_request_for_the_latest_version_tagged_with_'prod'_given_a_version_with_production_details_exists_for_the_Pricing_Service) given a version with production details exists for the Pricing Service

* [A request retrieve a pact for a specific version](#a_request_retrieve_a_pact_for_a_specific_version_given_the_'Pricing_Service'_and_'Condor'_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0) given the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0

* [A request to get the Pricing Service](#a_request_to_get_the_Pricing_Service_given_the_'Pricing_Service'_already_exists_in_the_pact-broker) given the 'Pricing Service' already exists in the pact-broker

* [A request to get the Pricing Service](#a_request_to_get_the_Pricing_Service_given_the_'Pricing_Service'_does_not_exist_in_the_pact-broker) given the 'Pricing Service' does not exist in the pact-broker

* [A request to list pacticipants](#a_request_to_list_pacticipants_given_'Condor'_exists_in_the_pact-broker) given 'Condor' exists in the pact-broker

* [A request to list the latest pacts](#a_request_to_list_the_latest_pacts_given_a_pact_between_Condor_and_the_Pricing_Service_exists) given a pact between Condor and the Pricing Service exists

* [A request to publish a pact](#a_request_to_publish_a_pact_given_the_'Pricing_Service'_and_'Condor'_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0) given the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0

* [A request to publish a pact](#a_request_to_publish_a_pact_given_'Condor'_already_exist_in_the_pact-broker,_but_the_'Pricing_Service'_does_not) given 'Condor' already exist in the pact-broker, but the 'Pricing Service' does not

* [A request to publish a pact](#a_request_to_publish_a_pact_given_the_'Pricing_Service'_already_exists_in_the_pact-broker) given the 'Pricing Service' already exists in the pact-broker

* [A request to publish a pact](#a_request_to_publish_a_pact_given_an_error_occurs_while_publishing_a_pact) given an error occurs while publishing a pact

* [A request to register the repository URL of a pacticipant](#a_request_to_register_the_repository_URL_of_a_pacticipant_given_the_'Pricing_Service'_already_exists_in_the_pact-broker) given the 'Pricing Service' already exists in the pact-broker

* [A request to register the repository URL of a pacticipant](#a_request_to_register_the_repository_URL_of_a_pacticipant_given_the_'Pricing_Service'_does_not_exist_in_the_pact-broker) given the 'Pricing Service' does not exist in the pact-broker

* [A request to retrieve the latest pact between Condor and the Pricing Service](#a_request_to_retrieve_the_latest_pact_between_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists) given a pact between Condor and the Pricing Service exists

* [A request to retrieve the latest pact between Condor and the Pricing Service](#a_request_to_retrieve_the_latest_pact_between_Condor_and_the_Pricing_Service_given_no_pact_between_Condor_and_the_Pricing_Service_exists) given no pact between Condor and the Pricing Service exists

* [A request to retrieve the pact between the production verison of Condor and the Pricing Service](#a_request_to_retrieve_the_pact_between_the_production_verison_of_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists_for_the_production_version_of_Condor) given a pact between Condor and the Pricing Service exists for the production version of Condor

* [A request to tag the production version of Condor](#a_request_to_tag_the_production_version_of_Condor_given_'Condor'_exists_in_the_pact-broker_with_version_1.3.0,_tagged_with_'prod') given 'Condor' exists in the pact-broker with version 1.3.0, tagged with 'prod'

* [A request to tag the production version of Condor](#a_request_to_tag_the_production_version_of_Condor_given_'Condor'_does_not_exist_in_the_pact-broker) given 'Condor' does not exist in the pact-broker

* [A request to tag the production version of Condor](#a_request_to_tag_the_production_version_of_Condor_given_'Condor'_exists_in_the_pact-broker) given 'Condor' exists in the pact-broker

#### Interactions

<a name="a_request_for_the_latest_version_given_no_version_exists_for_the_Pricing_Service"></a>
Given **no version exists for the Pricing Service**, upon receiving **a request for the latest version** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacticipants/Pricing%20Service/versions/latest",
  "headers": {
    "Accept": "application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 404
}
```
<a name="a_request_for_the_latest_version_tagged_with_'prod'_given_a_version_with_production_details_exists_for_the_Pricing_Service"></a>
Given **a version with production details exists for the Pricing Service**, upon receiving **a request for the latest version tagged with 'prod'** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pacticipants/Pricing%20Service/versions/latest",
  "query": "tag=prod",
  "headers": {
    "Accept": "application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "number": "1.2.3",
    "repository_ref": "package/pricing-service-1.2.3",
    "tags": [
      "prod"
    ]
  }
}
```
<a name="a_request_retrieve_a_pact_for_a_specific_version_given_the_'Pricing_Service'_and_'Condor'_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0**, upon receiving **a request retrieve a pact for a specific version** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
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
<a name="a_request_to_get_the_Pricing_Service_given_the_'Pricing_Service'_already_exists_in_the_pact-broker"></a>
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
      },
      "latest_version": {
        "href": "http://example.org/pacticipants/Pricing%20Service/versions/latest"
      }
    },
    "name": "Pricing Service",
    "repository_url": "git@git.realestate.com.au:business-systems/pricing-service",
    "_embedded": {
      "latest_version": {
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
<a name="a_request_to_get_the_Pricing_Service_given_the_'Pricing_Service'_does_not_exist_in_the_pact-broker"></a>
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
<a name="a_request_to_list_pacticipants_given_'Condor'_exists_in_the_pact-broker"></a>
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
          "latest_version": {
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
              "href": "http://example.org/pact/provider/Pricing%20Service/consumer/Condor/latest"
            },
            {
              "href": "http://example.org/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0"
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
<a name="a_request_to_publish_a_pact_given_the_'Pricing_Service'_and_'Condor'_already_exist_in_the_pact-broker,_and_Condor_already_has_a_pact_published_for_version_1.3.0"></a>
Given **the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0**, upon receiving **a request to publish a pact** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
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
  "status": 200
}
```
<a name="a_request_to_publish_a_pact_given_'Condor'_already_exist_in_the_pact-broker,_but_the_'Pricing_Service'_does_not"></a>
Given **'Condor' already exist in the pact-broker, but the 'Pricing Service' does not**, upon receiving **a request to publish a pact** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
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
  "status": 201
}
```
<a name="a_request_to_publish_a_pact_given_the_'Pricing_Service'_already_exists_in_the_pact-broker"></a>
Given **the 'Pricing Service' already exists in the pact-broker**, upon receiving **a request to publish a pact** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
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
  "status": 201
}
```
<a name="a_request_to_publish_a_pact_given_an_error_occurs_while_publishing_a_pact"></a>
Given **an error occurs while publishing a pact**, upon receiving **a request to publish a pact** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0",
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
    "Content-Type": "application/json"
  },
  "body": {
    "message": "An error occurred"
  }
}
```
<a name="a_request_to_register_the_repository_URL_of_a_pacticipant_given_the_'Pricing_Service'_already_exists_in_the_pact-broker"></a>
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
  "status": 200
}
```
<a name="a_request_to_register_the_repository_URL_of_a_pacticipant_given_the_'Pricing_Service'_does_not_exist_in_the_pact-broker"></a>
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
  "status": 201
}
```
<a name="a_request_to_retrieve_the_latest_pact_between_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists"></a>
Given **a pact between Condor and the Pricing Service exists**, upon receiving **a request to retrieve the latest pact between Condor and the Pricing Service** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pact/provider/Pricing%20Service/consumer/Condor/latest"
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/json",
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
  "path": "/pact/provider/Pricing%20Service/consumer/Condor/latest"
}
```
Pact Broker will respond with:
```json
{
  "status": 404
}
```
<a name="a_request_to_retrieve_the_pact_between_the_production_verison_of_Condor_and_the_Pricing_Service_given_a_pact_between_Condor_and_the_Pricing_Service_exists_for_the_production_version_of_Condor"></a>
Given **a pact between Condor and the Pricing Service exists for the production version of Condor**, upon receiving **a request to retrieve the pact between the production verison of Condor and the Pricing Service** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/pact/provider/Pricing%20Service/consumer/Condor/latest/prod",
  "headers": {
    "Accept": "application/json"
  }
}
```
Pact Broker will respond with:
```json
{
  "status": 200,
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
<a name="a_request_to_tag_the_production_version_of_Condor_given_'Condor'_exists_in_the_pact-broker_with_version_1.3.0,_tagged_with_'prod'"></a>
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
  "body": {
    "_links": {
      "self": {
        "href": "http://localhost:1234/pacticipants/Condor/versions/1.3.0/tags/prod"
      }
    }
  }
}
```
<a name="a_request_to_tag_the_production_version_of_Condor_given_'Condor'_does_not_exist_in_the_pact-broker"></a>
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
  "body": {
    "_links": {
      "self": {
        "href": "http://localhost:1234/pacticipants/Condor/versions/1.3.0/tags/prod"
      }
    }
  }
}
```
<a name="a_request_to_tag_the_production_version_of_Condor_given_'Condor'_exists_in_the_pact-broker"></a>
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
  "body": {
    "_links": {
      "self": {
        "href": "http://localhost:1234/pacticipants/Condor/versions/1.3.0/tags/prod"
      }
    }
  }
}
```
