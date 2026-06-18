# Developing

## Testing pact_broker-client locally

1. Make sure you have `ruby` available on the command line
2. Install with `bundle install`
3. Run tests with `bundle exec rake`
4. Run individual test with `rspec <path to test>`
5. Run one of the scripts in `./example/scripts`, see the readme for more detail, and scripts

##  Available Rake tasks

1. check `bundle exec rake --tasks`

## Generating docs

If you change the CLI commands, run `bundle exec script/update-cli-usage-in-readme.rb` to update the `README.md` automatically.

## Releasing

Releases are fully automated via the PR-driven flow in `.github/workflows/release.yml`.

1. **On every push to `master`**, the `prepare` job runs `scripts/release.rb prepare`, which uses git-cliff to compute the next semver, updates `lib/pact_broker/client/version.rb` and `CHANGELOG.md`, force-pushes the changes to the `release/pact-broker-client` branch, and creates or updates a **draft** release PR.

2. **When ready to release**, promote the PR from draft → ready-for-review. This triggers CI. You can edit `version.rb` or `CHANGELOG.md` directly on the `release/pact-broker-client` branch to make manual adjustments — those files are the source of truth.

3. **Merging the PR** triggers the `tag` job, which reads the version from `version.rb` and pushes a `v{version}` tag.

4. **The tag push** triggers the `publish` job: runs tests, builds the gem, creates a GitHub Release, and pushes to RubyGems via OIDC (no stored API key required).

### One-time setup (already done once per gem)

Configure OIDC trusted publishing on [rubygems.org](https://rubygems.org) for the `pact_broker-client` gem, trusting the `publish` job in `pact-foundation/pact_broker-client`.
