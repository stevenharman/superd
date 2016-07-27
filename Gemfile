source 'https://rubygems.org'

ruby '2.3.1'

gem 'puma', '~> 3.0'
gem 'sinatra', '~> 1.3'
gem 'sinatra-asset-pipeline'
gem 'bourbon', '~> 4.0'
gem 'activesupport'
# due to a dependency issue w/sinatra-asset-pipeline, we need to lock to 10.x for now
gem 'rake', '~> 10.0'

group :development, :test do
  gem 'foreman'
  gem 'rspec', '~> 3.4'
  gem 'rack-test'
  gem 'pry'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
end
