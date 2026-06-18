#!/usr/bin/env ruby
# frozen_string_literal: true

require 'open3'

RELEASE_BRANCH = 'release/pact-broker-client'
VERSION_FILE   = 'lib/pact_broker/client/version.rb'

def run!(cmd)
  out, status = Open3.capture2e(cmd)
  raise "Command failed: #{cmd}\n#{out}" unless status.success?
  out.strip
end

def run(cmd)
  out, = Open3.capture2e(cmd)
  out.strip
end

def prepare
  bumped = run!('git cliff --bumped-version').sub(/^v/, '')
  tag    = "v#{bumped}"
  current_tag = run('git describe --tags --abbrev=0 2>/dev/null')

  if current_tag == tag
    puts "No releasable commits since #{current_tag} — skipping."
    return
  end

  current_version = File.read(VERSION_FILE)[/VERSION = '([^']*)'/, 1]
  if current_version == bumped
    puts "version.rb already at #{bumped} — skipping (post-release race window)."
    return
  end

  puts "Preparing release #{tag}..."

  content = File.read(VERSION_FILE)
  File.write(VERSION_FILE, content.sub(/VERSION = '[^']*'/, "VERSION = '#{bumped}'"))

  run!("git cliff --unreleased --tag #{tag} --prepend CHANGELOG.md")
  run!("git add #{VERSION_FILE} CHANGELOG.md")
  run!("git commit -m 'chore: prepare release #{tag}'")
  run!("git push --force origin HEAD:#{RELEASE_BRANCH}")

  existing = run("gh pr list --head #{RELEASE_BRANCH} --json number --jq '.[0].number'")
  if existing.empty?
    run!("gh pr create --draft --title 'chore: release #{tag}' --body '' --head #{RELEASE_BRANCH} --base master")
    puts "Created draft release PR for #{tag}"
  else
    run!("gh pr edit #{existing} --title 'chore: release #{tag}'")
    puts "Updated release PR ##{existing} for #{tag}"
  end
end

def tag_release
  version = File.read(VERSION_FILE)[/VERSION = '([^']*)'/, 1]
  raise "Could not read version from #{VERSION_FILE}" unless version

  tag = "v#{version}"
  puts "Tagging #{tag}..."
  run!("git tag #{tag}")
  run!("git push origin #{tag}")
  puts "Pushed tag #{tag}"
end

case ARGV[0]
when 'prepare' then prepare
when 'tag'     then tag_release
else
  warn "Usage: #{$PROGRAM_NAME} prepare|tag"
  exit 1
end
