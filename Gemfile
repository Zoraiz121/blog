source "https://rubygems.org"

gem "devise"
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "sprockets-rails"
gem "sqlite3", ">= 1.4"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "aws-sdk-s3", require: false
gem "google-cloud-storage", "~> 1.11", require: false
gem "image_processing", "~> 1.2"

# Pagination
gem "pagy"

# SEO-friendly URLs — generates slugs from article titles automatically.
# /articles/1 becomes /articles/my-article-title
gem "friendly_id", "~> 5.5"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "letter_opener"
  gem "bullet"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
