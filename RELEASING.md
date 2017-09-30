# Releasing

1. Increment the version in `lib/pact_broker/client/version.rb`
2. `bundle exec appraisal update`
3. Update the `CHANGELOG.md` using:

      $ bundle exec rake generate_changelog

4. Add files to git

      $ git add CHANGELOG.md lib/pact_broker/client/version.rb gemfiles
      $ git commit -m "Releasing version $(ruby -r ./lib/pact_broker/client/version.rb -e "puts PactBroker::Client::VERSION")"

5. Release:

      $ bundle exec rake release
