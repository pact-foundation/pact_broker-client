FROM ruby:4.0.7-alpine@sha256:1ca7cb33e970630d571e0da6140e0bc925faec8f1f8f51f9f2cdf5e5f5eed7c9

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing hub
RUN apk add --update --no-cache git openssh bash
RUN gem update --system

RUN mkdir -p home
WORKDIR home
ADD release-image /
ENV BUNDLE_GEMFILE=/release/Gemfile
RUN bundle install
RUN git config --global user.email "beth@bethesque.com"
RUN git config --global user.name "Beth Skurrie via Github Actions"

ENTRYPOINT [/entrypoint.sh]
