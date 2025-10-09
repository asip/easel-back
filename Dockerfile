# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.4.7
FROM ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT="1"

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler


# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl libpq-dev libyaml-dev libvips node-gyp pkg-config python-is-python3 && \
    apt-get install --no-install-recommends -y git

# Install JavaScript dependencies
ARG NODE_VERSION=22.20.0
ARG PNPM_VERSION=10.18.1
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g pnpm@$PNPM_VERSION && \
    rm -rf /tmp/node-build-master

# Install application gems
COPY --link Gemfile Gemfile.lock ./
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf ~/.bundle/ $BUNDLE_PATH/ruby/*/cache $BUNDLE_PATH/ruby/*/bundler/gems/*/.git

# Install node modules
COPY --link .npmrc package.json pnpm-lock.yaml ./
RUN pnpm install

# Copy application code
COPY --link . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

ARG time_zone
ARG time_zone_db
ARG s3_access_key
ARG s3_secret_key
ARG s3_endpoint
ARG s3_bucket
ARG aws_region
ARG redis_session_url
ARG imgproxy_endpoint
ARG imgproxy_use_s3_urls
ARG imgproxy_shrine_host
ARG imgproxy_key
ARG imgproxy_salt
ENV TIME_ZONE=${time_zone}
ENV TIME_ZONE_DB=${time_zone_db}
ENV S3_ACCESS_KEY=${s3_access_key}
ENV S3_SECRET_KEY=${s3_secret_key}
ENV S3_ENDPOINT=${s3_endpoint}
ENV S3_BUCKET=${s3_bucket}
ENV AWS_REGION=${aws_region}
ENV REDIS_SESSION_URL=${redis_session_url}
ENV IMGPROXY_ENDPOINT=${imgproxy_endpoint}
ENV IMGPROXY_USE_S3_URLS=${imgproxy_use_s3_urls}
ENV IMGPROXY_SHRINE_HOST=${imgproxy_shrine_host}
ENV IMGPROXY_KEY=${imgproxy_key}
ENV IMGPROXY_SALT=${imgproxy_salt}

ENV TZ=${time_zone}

# Prepare icon fonts
RUN pnpm build:font

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl imagemagick libvips postgresql-client libjemalloc2 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
ARG UID=1000 \
    GID=1000
RUN groupadd -f -g $GID rails && \
    useradd -u $UID -g $GID rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
USER rails:rails

# Deployment options
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RUBY_YJIT_ENABLE="1"

ENV LD_PRELOAD="libjemalloc.so.2"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
