bundle exec bin/pact-broker create-or-update-pacticipant --name Foo
bundle exec bin/pact-broker create-version-tag --pacticipant Foo --version 2 --tag main --auto-create-version
bundle exec bin/pact-broker describe-version --pacticipant Foo --version 2
bundle exec bin/pact-broker create-environment --name test
bundle exec bin/pact-broker can-i-deploy --pacticipant Foo --version 2 --to-environment test

bundle exec bin/pact-broker record-deployment --pacticipant Foo --version 2 --environment test
bundle exec bin/pact-broker record-deployment --pacticipant Foo --version 2 --environment test --target customer-1
bundle exec bin/pact-broker record-deployment --pacticipant Foo --version 2 --environment test --application-instance customer-1

bundle exec bin/pact-broker record-undeployment --pacticipant Foo --environment test --application-instance customer-2
bundle exec bin/pact-broker record-undeployment --pacticipant Foo --environment test
bundle exec bin/pact-broker record-undeployment --pacticipant Foo --environment test
bundle exec bin/pact-broker record-undeployment --pacticipant Foo --environment test --application-instance customer-1

bundle exec bin/pact-broker record-release --pacticipant Foo --version 2 --environment test
bundle exec bin/pact-broker record-support-ended --pacticipant Foo --version 2 --environment test

bundle exec bin/pact-broker record-deployment --pacticipant Foo --version 2 --environment test
bundle exec bin/pact-broker record-deployment --pacticipant Foo --version 2 --environment test --application-instance customer-1
bundle exec bin/pact-broker record-deployment --pacticipant Foo --version 2 --environment test --application-instance customer-1

bundle exec bin/pact-broker record-undeployment --pacticipant Foo --environment test --application-instance customer-2
bundle exec bin/pact-broker record-undeployment --pacticipant Foo --environment test
bundle exec bin/pact-broker record-undeployment --pacticipant Foo --environment test
bundle exec bin/pact-broker record-undeployment --pacticipant Foo --environment test --application-instance customer-1
