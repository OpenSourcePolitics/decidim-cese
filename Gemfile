# frozen_string_literal: true

source "https://rubygems.org"

DECIDIM_VERSION = "release/0.27-stable"
ruby RUBY_VERSION

gem "decidim", git: "https://github.com/decidim/decidim.git", branch: DECIDIM_VERSION

## Block gems /!\ Required comment for : $ rake app:upgrade
# gem "acts_as_textcaptcha", "~> 4.5.1"
# gem "decidim-homepage_interactive_map", git: "https://github.com/OpenSourcePolitics/decidim-module-homepage_interactive_map.git", branch: "bump/0.25-stable"
# gem "decidim-phone_authorization_handler", git: "https://github.com/OpenSourcePolitics/decidim-module_phone_authorization_handler", branch: "bump/0.25-stable"
# gem "decidim-question_captcha", git: "https://github.com/OpenSourcePolitics/decidim-module-question_captcha.git", branch: DECIDIM_VERSION
# gem "decidim-spam_detection", git: "https://github.com/OpenSourcePolitics/decidim-spam_detection.git"
# gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git"
# gem "omniauth-france_connect", git: "https://github.com/OpenSourcePolitics/omniauth-france_connect"
# gem "omniauth-publik", git: "https://github.com/OpenSourcePolitics/omniauth-publik", branch: "v0.0.9"
#
# gem "decidim-decidim_awesome", "0.8.3"
## End gems /!\ Required comment for : $ rake app:upgrade

gem "activejob-uniqueness", require: "active_job/uniqueness/sidekiq_patch"
gem "dotenv-rails"
gem "fog-aws"
gem "foundation_rails_helper", git: "https://github.com/sgruhier/foundation_rails_helper.git"
gem "sys-filesystem"

gem "bootsnap", "~> 1.4"

gem "puma", ">= 5.6.2"

gem "faker", "~> 2.14"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman", "~> 5.2"
  gem "decidim-dev", git: "https://github.com/decidim/decidim.git", branch: DECIDIM_VERSION
  gem "parallel_tests", "~> 3.7"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "rubocop-faker"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "4.2"
end

group :production do
  gem "dalli"
  gem "lograge"
  gem "newrelic_rpm"
  gem "passenger"
  gem "sendgrid-ruby"
  gem "sentry-rails"
  gem "sentry-ruby"
  gem "sentry-sidekiq"
  gem "sidekiq"
  gem "sidekiq-scheduler"
end
