### A pact between Pact Broker Client V2 and PactFlow

#### Requests from Pact Broker Client V2 to PactFlow

* [A request for the index resource](#a_request_for_the_index_resource)

* [A request to create a provider contract](#a_request_to_create_a_provider_contract)

* [A request to create a provider contract](#a_request_to_create_a_provider_contract_given_there_is_a_pf:ui_href_in_the_response) given there is a pf:ui href in the response

* [A request to create a webhook for a team](#a_request_to_create_a_webhook_for_a_team_given_a_team_with_UUID_2abbc12a-427d-432a-a521-c870af1739d9_exists) given a team with UUID 2abbc12a-427d-432a-a521-c870af1739d9 exists

* [A request to publish a provider contract](#a_request_to_publish_a_provider_contract)

#### Interactions

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
PactFlow will respond with:
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
<a name="a_request_to_create_a_provider_contract"></a>
Upon receiving **a request to create a provider contract** from Pact Broker Client V2, with
```json
{
  "method": "PUT",
  "path": "/contracts/provider/Bar/version/1",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "content": "LS0tCnNvbWU6IGNvbnRyYWN0Cg==",
    "contentType": "application/yaml",
    "contractType": "oas",
    "verificationResults": {
      "content": "c29tZSByZXN1bHRz",
      "contentType": "text/plain",
      "format": "text",
      "success": true,
      "verifier": "my custom tool",
      "verifierVersion": "1.0"
    }
  }
}
```
PactFlow will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  }
}
```
<a name="a_request_to_create_a_provider_contract_given_there_is_a_pf:ui_href_in_the_response"></a>
Given **there is a pf:ui href in the response**, upon receiving **a request to create a provider contract** from Pact Broker Client V2, with
```json
{
  "method": "PUT",
  "path": "/contracts/provider/Bar/version/1",
  "headers": {
    "Accept": "application/hal+json",
    "Content-Type": "application/json"
  },
  "body": {
    "content": "LS0tCnNvbWU6IGNvbnRyYWN0Cg==",
    "contentType": "application/yaml",
    "contractType": "oas",
    "verificationResults": {
      "content": "c29tZSByZXN1bHRz",
      "contentType": "text/plain",
      "format": "text",
      "success": true,
      "verifier": "my custom tool",
      "verifierVersion": "1.0"
    }
  }
}
```
PactFlow will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pf:ui": {
        "href": "some-url"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_for_a_team_given_a_team_with_UUID_2abbc12a-427d-432a-a521-c870af1739d9_exists"></a>
Given **a team with UUID 2abbc12a-427d-432a-a521-c870af1739d9 exists**, upon receiving **a request to create a webhook for a team** from Pact Broker Client V2, with
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
      "url": "https://webhook"
    },
    "teamUuid": "2abbc12a-427d-432a-a521-c870af1739d9"
  }
}
```
PactFlow will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "self": {
        "href": "/some-url",
        "title": "A title"
      }
    },
    "description": "a webhook",
    "teamUuid": "2abbc12a-427d-432a-a521-c870af1739d9"
  }
}
```
<a name="a_request_to_publish_a_provider_contract"></a>
Upon receiving **a request to publish a provider contract** from Pact Broker Client V2, with
```json
{
  "method": "POST",
  "path": "/provider-contracts/provider/Bar/publish",
  "headers": {
    "Accept": "application/hal+json, application/problem+json",
    "Content-Type": "application/json"
  },
  "body": {
    "branch": "main",
    "buildUrl": "http://build",
    "contract": {
      "content": "LS0tCnNvbWU6IGNvbnRyYWN0Cg==",
      "contentType": "application/yaml",
      "selfVerificationResults": {
        "content": "c29tZSByZXN1bHRz",
        "contentType": "text/plain",
        "format": "text",
        "success": true,
        "verifier": "my custom tool",
        "verifierVersion": "1.0"
      },
      "specification": "oas"
    },
    "pacticipantVersionNumber": "1",
    "tags": [
      "dev"
    ]
  }
}
```
PactFlow will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_embedded": {
      "version": {
        "number": "1"
      }
    },
    "_links": {
      "pb:branch-version": {
        },
      "pb:pacticipant-version-tags": [
        {
        }
      ]
    },
    "notices": [
      {
        "text": "some notice",
        "type": "info"
      }
    ]
  }
}
```
