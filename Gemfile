source "https://rubygems.org"

ruby "3.3.8" # Keep in sync with .github/workflows/ci.yml

gem "puma", "~> 6.0"
gem "sinatra", "~> 2.0"
gem "sinatra-asset-pipeline", "~> 2.0"
gem "activesupport"
gem "barnes"

group :production do
  gem "newrelic_rpm"
end

group :development, :test do
  gem "rspec", "~> 3.4"
  gem "rack-test"
  gem "standard", "~> 1.43"
end

group :test do
  gem "simplecov", require: false
end
