### A pact between Pact Broker Client and Pact Broker

#### Requests from Pact Broker Client to Pact Broker

* [A request for the compatibility matrix for a pacticipant that does not exist](#a_request_for_the_compatibility_matrix_for_a_pacticipant_that_does_not_exist)

* [A request for the compatibility matrix for all versions of Foo and Bar](#a_request_for_the_compatibility_matrix_for_all_versions_of_Foo_and_Bar_given_the_pact_for_Foo_version_1.2.3_and_1.2.4_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 and 1.2.4 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_Thing_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo Thing version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix for Foo version 1.2.3 and Bar version 4.5.6](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_Bar_version_4.5.6_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix for Foo version 1.2.3 and the latest prod version of Bar](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_version_of_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_with_tag_prod,_and_1.2.4_unsuccessfully_by_9.9.9) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 with tag prod, and 1.2.4 unsuccessfully by 9.9.9

* [A request for the compatibility matrix for Foo version 1.2.3 and the latest prod versions of all other pacticipants](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_prod_versions_of_all_other_pacticipants_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6_(tagged_prod)_and_version_5.6.7) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6 (tagged prod) and version 5.6.7

* [A request for the compatibility matrix for Foo version 1.2.3 and the latest version of Bar](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_and_the_latest_version_of_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6,_and_1.2.4_unsuccessfully_by_9.9.9) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9

* [A request for the compatibility matrix for Foo version 1.2.3 to be deployed to the production environment](#a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_to_be_deployed_to_the_production_environment_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix where one or more versions does not exist](#a_request_for_the_compatibility_matrix_where_one_or_more_versions_does_not_exist_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6

* [A request for the compatibility matrix where only the version of Foo is specified](#a_request_for_the_compatibility_matrix_where_only_the_version_of_Foo_is_specified_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6_and_version_5.6.7) given the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6 and version 5.6.7

* [A request for the successful rows of the compatibility matrix for all versions of Foo and Bar](#a_request_for_the_successful_rows_of_the_compatibility_matrix_for_all_versions_of_Foo_and_Bar_given_the_pact_for_Foo_version_1.2.3_has_been_successfully_verified_by_Bar_version_4.5.6,_and_1.2.4_unsuccessfully_by_9.9.9) given the pact for Foo version 1.2.3 has been successfully verified by Bar version 4.5.6, and 1.2.4 unsuccessfully by 9.9.9

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
<a name="a_request_for_the_compatibility_matrix_for_Foo_version_1.2.3_to_be_deployed_to_the_production_environment_given_the_pact_for_Foo_version_1.2.3_has_been_verified_by_Bar_version_4.5.6"></a>
Given **the pact for Foo version 1.2.3 has been verified by Bar version 4.5.6**, upon receiving **a request for the compatibility matrix for Foo version 1.2.3 to be deployed to the production environment** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/matrix",
  "query": "q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bversion%5D=1.2.3&latestby=cvpv&environment=production"
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
