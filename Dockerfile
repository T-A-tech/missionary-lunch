# syntax=docker/dockerfile:1
FROM ruby:3.3.0-slim AS base

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Development stage
FROM base AS development

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUNDLE_PATH="/usr/local/bundle"

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

# Production build stage
FROM base AS build

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Production final stage
FROM base AS production

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /app /app

RUN mkdir -p db log storage tmp && \
    groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER 1000:1000

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
