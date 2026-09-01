ENV["RACK_ENV"] ||= "test"
require "simplecov"
SimpleCov.start

# The Gemfile's `require: "debug/prelude"` only takes effect via
# Bundler.require, which this app never calls - `bundle exec` just puts gems
# on the load path. So pull the prelude in explicitly to get binding.b and
# friends. It only defines the stubs; the real debugger loads on first hit.
require "debug/prelude"

require "rack/test"
require_relative "../app"

module SinatraTestAppHelpers
  include Rack::Test::Methods

  def app
    App
  end
end

RSpec.configure { |c| c.include SinatraTestAppHelpers }
