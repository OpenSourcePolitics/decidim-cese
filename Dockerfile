FROM ruby:3.0.6-slim as builder

ARG TARGETARCH

ENV RAILS_ENV=production \
    SECRET_KEY_BASE=dummy

WORKDIR /app

RUN apt-get update && \
    apt-get install -y libpq-dev curl git libicu-dev build-essential \
    libssl-dev libxrender1 libxext6 libfontconfig1 xfonts-75dpi xfonts-base && \
    curl https://deb.nodesource.com/setup_16.x | bash && \
    apt-get install -y nodejs && \
    npm install --global yarn && \
    gem install bundler:2.4.9

COPY Gemfile* ./
RUN bundle config set --local without 'development test' && \
    bundle install -j"$(nproc)"

COPY package* ./
COPY yarn.lock .
COPY packages packages
RUN yarn install --frozen-lockfile

COPY . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/ config/ bin/ db/ && \
    bundle exec rails assets:precompile

RUN rm -rf node_modules tmp/cache vendor/bundle spec \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete \
    && find /usr/local/bundle/gems/ -type d -name "spec" -prune -exec rm -rf {} \; \
    && rm -rf log/*.log

FROM ruby:3.0.6-slim as runner

ARG TARGETARCH

ENV RAILS_ENV=production \
    SECRET_KEY_BASE=dummy \
    RAILS_LOG_TO_STDOUT=true

RUN apt-get update && \
    apt-get install -y postgresql-client imagemagick libproj-dev proj-bin libjemalloc2 \
    libssl-dev libxrender1 libxext6 libfontconfig1 xfonts-75dpi xfonts-base curl && \
    WKHTML_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") && \
    curl -fsSL "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bullseye_${WKHTML_ARCH}.deb" \
    -o /tmp/wkhtmltox.deb && \
    apt-get install -y --no-install-recommends /tmp/wkhtmltox.deb && \
    rm /tmp/wkhtmltox.deb && \
    apt-get remove -y curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    gem install bundler:2.4.9

ADD https://letsencrypt.org/certs/isrg-root-x2.pem /etc/ssl/certs/ISRG_ROOT_X2.pem
RUN chmod 644 /etc/ssl/certs/ISRG_ROOT_X2.pem && update-ca-certificates && c_rehash

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

ENV LD_PRELOAD="libjemalloc.so.2" \
    MALLOC_CONF="background_thread:true,metadata_thp:auto,dirty_decay_ms:5000,muzzy_decay_ms:5000,narenas:2"

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]