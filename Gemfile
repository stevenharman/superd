source "https://rubygems.org"

ruby "2.7.2"

gem "puma", "~> 5.0"
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
  gem "simplecov", require: false
end
