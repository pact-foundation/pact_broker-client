# Releasing

1. Increment the version in `lib/pact_broker/client/version.rb`
2. `bundle exec appraisal update`
3. Update the `CHANGELOG.md` using:

      $ git log --pretty=format:'  * %h - %s (%an, %ad)' vX.Y.Z..HEAD

4. Add files to git

      $ git add CHANGELOG.md lib/pact_broker/client/version.rb
      $ git commit -m "Releasing version X.Y.Z"

5. Release:

      $ bundle exec rake release
