# frozen_string_literal: true

source "https://rubygems.org"

DECIDIM_VERSION = "0.27.1"
ruby RUBY_VERSION

gem "decidim", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION

gem "decidim-transparent_trash", git: "https://github.com/OpenSourcePolitics/decidim-module-transparent_trash.git", branch: "master"
## Block gems /!\ Required comment for : $ rake app:upgrade
gem "decidim-blog_author_petition", git: "https://github.com/OpenSourcePolitics/decidim-module-blog_author_petition.git", branch: "main"
gem "decidim-decidim_awesome", git: "https://github.com/decidim-ice/decidim-module-decidim_awesome.git", branch: "main"
gem "decidim-initiative_status", git: "https://github.com/OpenSourcePolitics/decidim-module-initiative_status.git", branch: "main"
# gem "acts_as_textcaptcha", "~> 4.5.1"
# gem "decidim-homepage_interactive_map", git: "https://github.com/OpenSourcePolitics/decidim-module-homepage_interactive_map.git", branch: "bump/0.25-stable"
# gem "decidim-phone_authorization_handler", git: "https://github.com/OpenSourcePolitics/decidim-module_phone_authorization_handler", branch: "bump/0.25-stable"
gem "decidim-extended_socio_demographic_authorization_handler", git: "https://github.com/OpenSourcePolitics/decidim-module-extended_socio_demographic_authorization_handler.git",
                                                                branch: "cese"
# gem "decidim-question_captcha", git: "https://github.com/OpenSourcePolitics/decidim-module-question_captcha.git", branch: DECIDIM_VERSION
# gem "decidim-spam_detection", git: "https://github.com/OpenSourcePolitics/decidim-spam_detection.git"
gem "decidim-spam_detection"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git", branch: "develop"
gem "omniauth-france_connect", git: "https://github.com/OpenSourcePolitics/omniauth-france_connect"

# gem "omniauth-publik", git: "https://github.com/OpenSourcePolitics/omniauth-publik", branch: "v0.0.9"

## End gems /!\ Required comment for : $ rake app:upgrade

gem "activejob-uniqueness", require: "active_job/uniqueness/sidekiq_patch"
gem "dotenv-rails"
gem "fog-aws"
gem "foundation_rails_helper", git: "https://github.com/sgruhier/foundation_rails_helper.git"
gem "rack-attack"
gem "sys-filesystem"

gem "omniauth-rails_csrf_protection", "~> 1.0"

gem "bootsnap", "~> 1.4"
gem "puma", ">= 5.6.2"

gem "deface"
gem "faker", "~> 2.14"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman", "~> 5.2"
  gem "decidim-dev", DECIDIM_VERSION
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
  gem "sidekiq", "~> 6.0"
  gem "sidekiq-scheduler", "~> 5.0"
end
