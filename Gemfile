source "https://rubygems.org"

ruby "2.7.1"

gem "puma", "~> 4.0"
gem "sinatra", "~> 2.0"
gem "sinatra-asset-pipeline", "~> 2.0"
gem "activesupport"
gem "barnes"

group :production do
  gem "newrelic_rpm"
end

group :development, :test do
  gem "foreman"
  gem "rspec", "~> 3.4"
  gem "rack-test"
  gem "pry-byebug"
end

group :test do
  # Workaround for cc-test-reporter with SimpleCov 0.18.
  # Stop upgrading SimpleCov until the following issue will be resolved.
  # https://github.com/codeclimate/test-reporter/issues/418
  gem "simplecov", ">= 0.17.1", "< 0.18", require: false
end
