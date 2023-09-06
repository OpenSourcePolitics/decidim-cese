# frozen_string_literal: true

source "https://rubygems.org"

DECIDIM_VERSION = "0.27"
DECIDIM_BRANCH = "release/#{DECIDIM_VERSION}-stable".freeze

ruby RUBY_VERSION

# Many gems depend on environment variables, so we load them as soon as possible
gem "dotenv-rails", require: "dotenv/rails-now"

# Core gems
gem "decidim", "~> #{DECIDIM_VERSION}.0"
gem "decidim-initiatives", "~> #{DECIDIM_VERSION}.0"

# External Decidim gems
gem "decidim-blog_author_petition", git: "https://github.com/OpenSourcePolitics/decidim-module-blog_author_petition.git", branch: "main"
gem "decidim-decidim_awesome", git: "https://github.com/decidim-ice/decidim-module-decidim_awesome.git", branch: "main"
gem "decidim-extended_socio_demographic_authorization_handler", git: "https://github.com/OpenSourcePolitics/decidim-module-extended_socio_demographic_authorization_handler.git",
                                                                branch: "cese"
gem "decidim-initiative_status", git: "https://github.com/OpenSourcePolitics/decidim-module-initiative_status.git", branch: "main"
gem "decidim-spam_detection"
gem "decidim-term_customizer", git: "https://github.com/armandfardeau/decidim-module-term_customizer.git", branch: "fix/precompile-on-docker-0.27"
gem "decidim-transparent_trash", git: "https://github.com/OpenSourcePolitics/decidim-module-transparent_trash.git", branch: "master"

# Omniauth gems
gem "omniauth-france_connect", git: "https://github.com/OpenSourcePolitics/omniauth-france_connect"

# Default
gem "activejob-uniqueness", require: "active_job/uniqueness/sidekiq_patch"
gem "activerecord-session_store"
gem "aws-sdk-s3", require: false
gem "bootsnap", "~> 1.4"
gem "deface"
gem "faker", "~> 2.14"
gem "fog-aws"
gem "foundation_rails_helper", git: "https://github.com/sgruhier/foundation_rails_helper.git"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "puma", ">= 5.6.2"
gem "rack-attack"
gem "sys-filesystem"

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "rubocop-faker"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "4.2"
end

group :development, :test do
  gem "brakeman", "~> 5.2"
  gem "byebug", "~> 11.0", platform: :mri
  gem "climate_control", "~> 1.2"
  gem "decidim-dev", "~> #{DECIDIM_VERSION}.0"
  gem "parallel_tests", "~> 3.7"
end

group :production do
  gem "dalli"
  gem "health_check", "~> 3.1"
  gem "lograge"
  gem "sendgrid-ruby"
  gem "sentry-rails"
  gem "sentry-ruby"
  gem "sentry-sidekiq"
  gem "sidekiq", "~> 6.0"
  gem "sidekiq_alive", "~> 2.2"
  gem "sidekiq-scheduler", "~> 5.0"
end
