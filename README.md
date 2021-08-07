# Pact Broker Client

A client for the Pact Broker. Publishes and retrieves pacts, verification results, pacticipants, pacticipant versions and tags. The functionality is available via a CLI, or via Ruby Rake tasks. You can also use the [Pact CLI Docker image](https://hub.docker.com/r/pactfoundation/pact-cli).

![Build status](https://github.com/pact-foundation/pact_broker-client/workflows/Test/badge.svg)

[![Gem Version](https://badge.fury.io/rb/pact_broker-client.svg)](http://badge.fury.io/rb/pact_broker-client)

![Trigger update to docs.pact.io](https://github.com/pact-foundation/pact_broker-client/workflows/Trigger%20update%20to%20docs.pact.io/badge.svg)

## Installation

### CLI

Download the latest [pact-ruby-standalone][pact-ruby-standalone] package. You do not need Ruby to run the CLI, as the Ruby runtime is packaged with the executable using Travelling Ruby.

### Ruby

Add `gem 'pact_broker-client'` to your Gemfile and run `bundle install`, or install the gem directly by running `gem install pact_broker-client`.

## Connecting to a Pact Broker with a self signed certificate

To connect to a Pact Broker that uses custom SSL cerificates, set the environment variable `$SSL_CERT_FILE` or `$SSL_CERT_DIR` to a path that contains the appropriate certificate. Read more at https://docs.pact.io/pact_broker/advanced_topics/using-tls#for-non-jvm

## Usage - CLI

The Pact Broker base URL can be specified either using the environment variable `$PACT_BROKER_BASE_URL` or the `-b` or `--broker-base-url` parameters.

Pact Broker authentication can be performed either using basic auth or a bearer token.

Basic auth parameters can be specified using the `$PACT_BROKER_USERNAME` and `$PACT_BROKER_PASSWORD` environment variables, or the `-u` or `--broker-username` and `-p` or `--broker-password` parameters.

Authentication using a bearer token can be specified using the environment variable `$PACT_BROKER_TOKEN` or the `-k` or `--broker-token` parameters. This authentication system is used by [Pactflow](pactflow.io).

### Pacts

#### publish

```
Usage:
  pact-broker publish PACT_DIRS_OR_FILES ... -a, --consumer-app-version=CONSUMER_APP_VERSION -b, --broker-base-url=BROKER_BASE_URL

Options:
  -a, --consumer-app-version=CONSUMER_APP_VERSION                                
              # The consumer application version
  -h, [--branch=BRANCH]                                                          
              # Repository branch of the consumer version
      [--auto-detect-version-properties], [--no-auto-detect-version-properties]  
              # Automatically detect the repository branch from known CI
                environment variables or git CLI.
  -t, [--tag=TAG]                                                                
              # Tag name for consumer version. Can be specified multiple
                times.
  -g, [--tag-with-git-branch], [--no-tag-with-git-branch]                        
              # Tag consumer version with the name of the current git branch.
                Default: false
      [--build-url=BUILD_URL]                                                    
              # The build URL that created the pact
      [--merge], [--no-merge]                                                    
              # If a pact already exists for this consumer version and
                provider, merge the contents. Useful when running Pact tests
                concurrently on different build nodes.
  -o, [--output=OUTPUT]                                                          
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL                                          
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]                                        
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]                                        
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]                                              
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]                                                
              # Verbose output. Default: false
```

Publish pacts to a Pact Broker.

#### list-latest-pact-versions

```
Usage:
  pact-broker list-latest-pact-versions -b, --broker-base-url=BROKER_BASE_URL

Options:
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
  -o, [--output=OUTPUT]                    
              # json or table
              # Default: table
```

List the latest pact for each integration

### Environments

#### create-environment

```
Usage:
  pact-broker create-environment --name=NAME -b, --broker-base-url=BROKER_BASE_URL

Options:
      --name=NAME                                      
              # The uniquely identifying name of the environment as used in
                deployment code
      [--display-name=DISPLAY_NAME]                    
              # The display name of the environment
      [--production], [--no-production]                
              # Whether or not this environment is a production environment.
                Default: false
      [--contact-name=CONTACT_NAME]                    
              # The name of the team/person responsible for this environment
      [--contact-email-address=CONTACT_EMAIL_ADDRESS]  
              # The email address of the team/person responsible for this
                environment
  -o, [--output=OUTPUT]                                
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL                
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]              
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]              
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]                    
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]                      
              # Verbose output. Default: false
```

Create an environment resource in the Pact Broker to represent a real world deployment or release environment.

#### update-environment

```
Usage:
  pact-broker update-environment --uuid=UUID -b, --broker-base-url=BROKER_BASE_URL

Options:
      --uuid=UUID                                      
              # The UUID of the environment to update
      [--name=NAME]                                    
              # The uniquely identifying name of the environment as used in
                deployment code
      [--display-name=DISPLAY_NAME]                    
              # The display name of the environment
      [--production], [--no-production]                
              # Whether or not this environment is a production environment.
                Default: false
      [--contact-name=CONTACT_NAME]                    
              # The name of the team/person responsible for this environment
      [--contact-email-address=CONTACT_EMAIL_ADDRESS]  
              # The email address of the team/person responsible for this
                environment
  -o, [--output=OUTPUT]                                
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL                
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]              
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]              
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]                    
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]                      
              # Verbose output. Default: false
```

Update an environment resource in the Pact Broker.

#### describe-environment

```
Usage:
  pact-broker describe-environment --uuid=UUID -b, --broker-base-url=BROKER_BASE_URL

Options:
      --uuid=UUID                          
              # The UUID of the environment to describe
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Describe an environment

#### delete-environment

```
Usage:
  pact-broker delete-environment --uuid=UUID -b, --broker-base-url=BROKER_BASE_URL

Options:
      --uuid=UUID                          
              # The UUID of the environment to delete
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Delete an environment

#### list-environments

```
Usage:
  pact-broker list-environments -b, --broker-base-url=BROKER_BASE_URL

Options:
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

List environments

### Deployments

#### record-deployment

```
Usage:
  pact-broker record-deployment --environment=ENVIRONMENT -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL -e, --version=VERSION

Options:
  -a, --pacticipant=PACTICIPANT            
              # The name of the pacticipant that was deployed.
  -e, --version=VERSION                    
              # The pacticipant version number that was deployed.
      --environment=ENVIRONMENT            
              # The name of the environment that the pacticipant version was
                deployed to.
      [--target=TARGET]                    
              # Optional. The target of the deployment - a logical identifer
                required to differentiate deployments when there are multiple
                instances of the same application in an environment.
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Record deployment of a pacticipant version to an environment. See https://docs.pact.io/record-deployment for more information.

#### record-undeployment

```
Usage:
  pact-broker record-undeployment --environment=ENVIRONMENT -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL

Options:
  -a, --pacticipant=PACTICIPANT            
              # The name of the pacticipant that was undeployed.
      --environment=ENVIRONMENT            
              # The name of the environment that the pacticipant version was
                undeployed from.
      [--target=TARGET]                    
              # Optional. The target that the application is being undeployed
                from - a logical identifer required to differentiate
                deployments when there are multiple instances of the same
                application in an environment.
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Description:
  Note that use of this command is only required if you are permanently removing an application instance from an environment. It is not required if you are
  deploying over a previous version, as record-deployment will automatically mark the previously deployed version as undeployed for you. See
  https://docs.pact.io/record-undeployment for more information.

### Releases

#### record-release

```
Usage:
  pact-broker record-release --environment=ENVIRONMENT -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL -e, --version=VERSION

Options:
  -a, --pacticipant=PACTICIPANT            
              # The name of the pacticipant that was released.
  -e, --version=VERSION                    
              # The pacticipant version number that was released.
      --environment=ENVIRONMENT            
              # The name of the environment that the pacticipant version was
                released to.
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Record release of a pacticipant version to an environment. See See https://docs.pact.io/record-release for more information.

#### record-support-ended

```
Usage:
  pact-broker record-support-ended --environment=ENVIRONMENT -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL -e, --version=VERSION

Options:
  -a, --pacticipant=PACTICIPANT            
              # The name of the pacticipant.
  -e, --version=VERSION                    
              # The pacticipant version number for which support is ended.
      --environment=ENVIRONMENT            
              # The name of the environment in which the support is ended.
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Record the end of support for a pacticipant version in an environment. See https://docs.pact.io/record-support-ended for more information.

### Matrix

#### can-i-deploy

```
Usage:
  pact-broker can-i-deploy -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL

Options:
  -a, --pacticipant=PACTICIPANT            
              # The pacticipant name. Use once for each pacticipant being
                checked.
  -e, [--version=VERSION]                  
              # The pacticipant version. Must be entered after the
                --pacticipant that it relates to.
      [--ignore=IGNORE]                    
              # The pacticipant name to ignore. Use once for each pacticipant
                being ignored. A specific version can be ignored by also
                specifying a --version after the pacticipant name option.
  -l, [--latest=[TAG]]                     
              # Use the latest pacticipant version. Optionally specify a TAG
                to use the latest version with the specified tag.
      [--to-environment=ENVIRONMENT]       
              # The environment into which the pacticipant(s) are to be
                deployed
      [--to=TAG]                           
              # This is too hard to explain in a short sentence. Look at the
                examples.
  -o, [--output=OUTPUT]                    
              # json or table
              # Default: table
      [--retry-while-unknown=TIMES]        
              # The number of times to retry while there is an unknown
                verification result (ie. the provider verification is likely
                still running)
              # Default: 0
      [--retry-interval=SECONDS]           
              # The time between retries in seconds. Use in conjuction with
                --retry-while-unknown
              # Default: 10
      [--dry-run], [--no-dry-run]          
              # When dry-run is enabled, always exit process with a success
                code. Can also be enabled by setting the environment variable
                PACT_BROKER_CAN_I_DEPLOY_DRY_RUN=true.
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Description:
  Returns exit code 0 or 1, indicating whether or not the specified application (pacticipant) versions are compatible (ie. safe to deploy). Prints out the relevant
  pact/verification details, indicating any missing or failed verification results.

  The environment variables PACT_BROKER_BASE_URL, PACT_BROKER_USERNAME and PACT_BROKER_PASSWORD may be used instead of their respective command line options.

  There are two ways to use `can-i-deploy`. The first (recommended and most commonly used) approach is to specify just the application version you want to deploy
  and let the Pact Broker work out the dependencies for you. The second approach is to specify each application version explicitly. This would generally only
  be used if there were limitations that stopped you being able to use the first approach.

  #### Specifying an application version

  To specify an application (pacticipant) version you need to provide:

  * the name of the application using the `--pacticipant PACTICIPANT` parameter, * directly followed by *one* of the following parameters: * `--version VERSION`
  to specify a known application version (recommended) * `--latest` to specify the latest version * `--latest TAG` to specify the latest version that has a
  particular tag * `--all TAG` to specify all the versions that have a particular tag (eg. "all prod" versions). This would be used when ensuring you have
  backwards compatiblity with all production mobile clients for a provider. Note, when using this option, you need to specify dependency explicitly (see the
  second usage option).

  Using a specific version is the easiest way to ensure you get an accurate response that won't be affected by race conditions.

  #### Recommended usage - allowing the Pact Broker to automatically determine the dependencies

  Prerequisite: if you would like the Pact Broker to calculate the dependencies for you when you want to deploy an application into a given environment, you will need to
  let the Broker know which version of each application is in that environment.

  How you do this depends on the version of the Pact Broker you are running.

  If you are using a Broker version where deployment versions are supported, then you would notify the Broker of the deployment of this application version like
  so:

  $ pact-broker record-deployment --pacticipant Foo --version 173153ae0 --environment test

  This assumes that you have already set up an environment named "test" in the Broker.

  If you are using a Broker version that does not support deployment environments, then you will need to use tags to notify the broker of the deployment of this
  application version, like so:

  $ pact-broker create-version-tag --pacticipant Foo --version 173153ae0 --tag test

  Once you have configured your build to notify the Pact Broker of the successful deployment using either method describe above, you can use the following simple
  command to find out if you are safe to deploy (use either `--to` or `--to-environment` as supported):

  $ pact-broker can-i-deploy --pacticipant PACTICIPANT --version VERSION [--to-environment ENVIRONMENT | --to ENVIRONMENT_TAG ] --broker-base-url
  BROKER_BASE_URL

  If the `--to` or `--to-environment` options are omitted, then the query will return the compatiblity with the overall latest version of each of the other
  applications.

  Examples:

  Can I deploy version 173153ae0 of application Foo to the test environment?

  $ pact-broker can-i-deploy --pacticipant Foo --version 173153ae0 \ --to-environment test \ --broker-base-url https://my-pact-broker

  Can I deploy the latest version of application Foo with the latest version of each of the applications it integrates to?

  $ pact-broker can-i-deploy --pacticipant Foo --latest \ --broker-base-url https://my-pact-broker

  Can I deploy the latest version of the application Foo that has the tag "test" to the "prod" environment?

  $ pact-broker can-i-deploy --pacticipant Foo --latest test \ --to prod \ --broker-base-url https://my-pact-broker

  #### Alternate usage - specifying dependencies explicitly

  If you are unable to use tags, or there is some other limitation that stops you from using the recommended approach, you can specify one or more of the
  dependencies explictly. You must also do this if you want to use the `--all TAG` option for any of the pacticipants.

  You can specify as many application versions as you like, and you can even specify multiple versions of the same application (repeat the `--pacticipant` name
  and supply a different version.)

  You can use explictly declared dependencies with or without the `--to ENVIRONMENT_TAG`. For example, if you declare two (or more) application versions with no
  `--to ENVIRONMENT_TAG`, then only the applications you specify will be taken into account when determining if it is safe to deploy. If you declare two (or
  more) application versions _as well as_ a `--to ENVIRONMENT`, then the Pact Broker will work out what integrations your declared applications will have in
  that environment when determining if it safe to deploy. When using this script for a production release, and you are using tags, it is always the most
  future-proof option to use the `--to` if possible, as it will catch any newly added consumers or providers.

  If you are finding that your dependencies are not being automatically included when you supply multiple pacticipant versions, please upgrade to the latest
  version of the Pact Broker, as this is a more recently added feature.

  $ pact-broker can-i-deploy --pacticipant PACTICIPANT_1 [--version VERSION_1 | --latest [TAG_1] | --all TAG_1] \ --pacticipant PACTICIPANT_2 [--version
  VERSION_2 | --latest [TAG_2] | --all TAG_2] \ [--to-environment ENVIRONMENT | --to ENVIRONMENT_TAG] \ --broker-base-url BROKER_BASE_URL

  Examples:

  Can I deploy version Foo version 173153ae0 and Bar version ac23df1e8 together?

  $ pact-broker can-i-deploy --pacticipant Foo --version 173153ae0 \ --pacticipant Bar --version ac23df1e8 \ --broker-base-url BROKER_BASE_URL

  Can I deploy the latest version of Foo with tag "master" and the latest version of Bar with tag "master" together?

  $ pact-broker can-i-deploy --pacticipant Foo --latest master \ --pacticipant Bar --latest master \ --broker-base-url BROKER_BASE_URL

  Mobile provider use case - can I deploy version b80e7b1b of Bar, all versions of Foo with tag "prod", and the latest version tagged "prod" of any other
  automatically calculated dependencies together? (Eg. where Bar is a provider and Foo is a mobile consumer with multiple versions in production, and Bar also
  has its own providers it needs to be compatible with.)

  $ pact-broker can-i-deploy --pacticipant Bar --version b80e7b1b \ --pacticipant Foo --all prod \ --to prod \ --broker-base-url BROKER_BASE_URL

### Pacticipants

#### create-or-update-pacticipant

```
Usage:
  pact-broker create-or-update-pacticipant --name=NAME -b, --broker-base-url=BROKER_BASE_URL

Options:
      --name=NAME                          
              # Pacticipant name
      [--display-name=DISPLAY_NAME]        
              # Display name
      [--repository-url=REPOSITORY_URL]    
              # The repository URL of the pacticipant
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Create or update pacticipant by name

#### describe-pacticipant

```
Usage:
  pact-broker describe-pacticipant --name=NAME -b, --broker-base-url=BROKER_BASE_URL

Options:
      --name=NAME                          
              # Pacticipant name
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Describe a pacticipant

#### list-pacticipants

```
Usage:
  pact-broker list-pacticipants -b, --broker-base-url=BROKER_BASE_URL

Options:
  -o, [--output=OUTPUT]                    
              # json or text
              # Default: text
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

List pacticipants

### Webhooks

#### create-webhook

```
Usage:
  pact-broker create-webhook URL -X, --request=METHOD -b, --broker-base-url=BROKER_BASE_URL

Options:
  -X, --request=METHOD                                                             
              # Webhook HTTP method
  -H, [--header=one two three]                                                     
              # Webhook Header
  -d, [--data=DATA]                                                                
              # Webhook payload (file or string)
  -u, [--user=USER]                                                                
              # Webhook basic auth username and password eg. username:password
      [--consumer=CONSUMER]                                                        
              # Consumer name
      [--provider=PROVIDER]                                                        
              # Provider name
      [--description=DESCRIPTION]                                                  
              # Webhook description
      [--contract-content-changed], [--no-contract-content-changed]                
              # Trigger this webhook when the pact content changes
      [--contract-published], [--no-contract-published]                            
              # Trigger this webhook when a pact is published
      [--provider-verification-published], [--no-provider-verification-published]  
              # Trigger this webhook when a provider verification result is
                published
      [--provider-verification-failed], [--no-provider-verification-failed]        
              # Trigger this webhook when a failed provider verification
                result is published
      [--provider-verification-succeeded], [--no-provider-verification-succeeded]  
              # Trigger this webhook when a successful provider verification
                result is published
      [--team-uuid=UUID]                                                           
              # UUID of the Pactflow team to which the webhook should be
                assigned (Pactflow only)
  -b, --broker-base-url=BROKER_BASE_URL                                            
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]                                          
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]                                          
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]                                                
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]                                                  
              # Verbose output. Default: false
```

Description:
  Create a curl command that executes the request that you want your webhook to execute, then replace "curl" with "pact-broker create-webhook" and add the consumer,
  provider, event types and broker details. Note that the URL must be the first parameter when executing create-webhook.

  Note that the -u option from the curl command clashes with the -u option from the pact-broker CLI. When used in this command, the -u will be used as a curl
  option. Please use the --broker-username or environment variable for the Pact Broker username.

#### create-or-update-webhook

```
Usage:
  pact-broker create-or-update-webhook URL --uuid=UUID -X, --request=METHOD -b, --broker-base-url=BROKER_BASE_URL

Options:
  -X, --request=METHOD                                                             
              # Webhook HTTP method
  -H, [--header=one two three]                                                     
              # Webhook Header
  -d, [--data=DATA]                                                                
              # Webhook payload (file or string)
  -u, [--user=USER]                                                                
              # Webhook basic auth username and password eg. username:password
      [--consumer=CONSUMER]                                                        
              # Consumer name
      [--provider=PROVIDER]                                                        
              # Provider name
      [--description=DESCRIPTION]                                                  
              # Webhook description
      [--contract-content-changed], [--no-contract-content-changed]                
              # Trigger this webhook when the pact content changes
      [--contract-published], [--no-contract-published]                            
              # Trigger this webhook when a pact is published
      [--provider-verification-published], [--no-provider-verification-published]  
              # Trigger this webhook when a provider verification result is
                published
      [--provider-verification-failed], [--no-provider-verification-failed]        
              # Trigger this webhook when a failed provider verification
                result is published
      [--provider-verification-succeeded], [--no-provider-verification-succeeded]  
              # Trigger this webhook when a successful provider verification
                result is published
      [--team-uuid=UUID]                                                           
              # UUID of the Pactflow team to which the webhook should be
                assigned (Pactflow only)
  -b, --broker-base-url=BROKER_BASE_URL                                            
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]                                          
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]                                          
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]                                                
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]                                                  
              # Verbose output. Default: false
      --uuid=UUID                                                                  
              # Specify the uuid for the webhook
```

Description:
  Create a curl command that executes the request that you want your webhook to execute, then replace "curl" with "pact-broker create-or-update-webhook" and add the
  consumer, provider, event types and broker details. Note that the URL must be the first parameter when executing create-or-update-webhook and a uuid must
  also be provided. You can generate a valid UUID by using the `generate-uuid` command.

  Note that the -u option from the curl command clashes with the -u option from the pact-broker CLI. When used in this command, the -u will be used as a curl
  option. Please use the --broker-username or environment variable for the Pact Broker username.

#### test-webhook

```
Usage:
  pact-broker test-webhook --uuid=UUID -b, --broker-base-url=BROKER_BASE_URL

Options:
      --uuid=UUID                          
              # Specify the uuid for the webhook
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Test the execution of a webhook

### Tags

#### create-version-tag

```
Usage:
  pact-broker create-version-tag -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL -e, --version=VERSION

Options:
  -a, --pacticipant=PACTICIPANT                            
              # The pacticipant name
  -e, --version=VERSION                                    
              # The pacticipant version
  -t, [--tag=TAG]                                          
              # Tag name for pacticipant version. Can be specified multiple
                times.
      [--auto-create-version], [--no-auto-create-version]  
              # Automatically create the pacticipant version if it does not
                exist. Default: false
  -g, [--tag-with-git-branch], [--no-tag-with-git-branch]  
              # Tag pacticipant version with the name of the current git
                branch. Default: false
  -b, --broker-base-url=BROKER_BASE_URL                    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]                  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]                  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]                        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]                          
              # Verbose output. Default: false
```

Add a tag to a pacticipant version

### Versions

#### describe-version

```
Usage:
  pact-broker describe-version -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL

Options:
  -a, --pacticipant=PACTICIPANT            
              # The name of the pacticipant that the version belongs to.
  -e, [--version=VERSION]                  
              # The pacticipant version number.
  -l, [--latest=[TAG]]                     
              # Describe the latest pacticipant version. Optionally specify a
                TAG to describe the latest version with the specified tag.
  -o, [--output=OUTPUT]                    
              # json or table or id
              # Default: table
  -b, --broker-base-url=BROKER_BASE_URL    
              # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  
              # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  
              # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        
              # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]          
              # Verbose output. Default: false
```

Describes a pacticipant version. If no version or tag is specified, the latest version is described.

### Miscellaneous

#### generate-uuid

```
Usage:
  pact-broker generate-uuid

Options:
```

Generate a UUID for use when calling create-or-update-webhook

## Usage - Ruby

### Consumer

```ruby
# In Gemfile

gem "pact_broker-client"
```

```ruby
# In Rakefile

require 'pact_broker/client/tasks'

PactBroker::Client::PublicationTask.new do | task |
  require 'my_consumer/version'
  task.consumer_version = MyConsumer::VERSION
  task.pattern = 'custom/path/to/pacts/*.json' # optional, default value is 'spec/pacts/*.json'
  task.pact_broker_base_url = "http://pact-broker"
  task.tag_with_git_branch = true|false # Optional but STRONGLY RECOMMENDED as it will greatly assist with your pact workflow. Result will be merged with other specified task.tags
  task.tags = ["dev"] # optional
  task.pact_broker_basic_auth =  { username: 'basic_auth_user', password: 'basic_auth_pass'} # optional
  task.pact_broker_token = "1234abcd" # Bearer token
  task.write_method = :merge # optional, this will merge the published pact into an existing pact rather than overwriting it if one exists. Not recommended, as it makes a mulch of the workflow on the broker.
end
```

```bash
# In CI script

bundle exec rake pact:publish
```

[pact-ruby-standalone]: https://github.com/pact-foundation/pact-ruby-standalone/releases
[docker]: https://hub.docker.com/r/pactfoundation/pact-cli
