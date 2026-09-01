source "https://rubygems.org"

ruby "3.4.10" # Keep in sync with .github/workflows/ci.yml

gem "puma", "~> 6.0"
gem "rackup"
gem "sinatra", "~> 4.0"
gem "activesupport"
gem "barnes", "~> 1.0"
gem "rake", "~> 13.0"
gem "sass-embedded"

group :production do
  gem "newrelic_rpm"
end

group :development, :test do
  gem "debug"
  gem "rspec", "~> 3.4"
  gem "rack-test"
  gem "standard", "~> 1.43"
end

group :test do
  gem "simplecov", require: false
end
