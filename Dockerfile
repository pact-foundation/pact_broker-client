FROM ruby:4.0.9-alpine@sha256:f1e530793cc09e1093417a4c9956069407155e1883d02beb30bda35ae54a47a3

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
