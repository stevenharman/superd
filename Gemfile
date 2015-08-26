source 'https://rubygems.org'

ruby '2.2.3'

gem 'puma', '~> 2.0'
gem 'sinatra', '~> 1.3'
gem 'sinatra-asset-pipeline'
gem 'bourbon', '~> 4.0.0.rc1'
gem 'activesupport'
gem 'rake', '~> 10.0'

group :development, :test do
  gem 'foreman'
  gem 'rspec', '~> 2.14'
  gem 'rack-test'
  gem 'pry'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil

  # Require Simplecov explicitly. Remove this explicit dependency when
  # the following is fixed: https://github.com/colszowka/simplecov/issues/281
  gem 'simplecov', '~> 0.7.1'
end
