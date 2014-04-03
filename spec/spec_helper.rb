ENV['RACK_ENV'] ||= 'test'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rack/test'
require_relative '../app.rb'

module SinatraTestAppHelpers
  include Rack::Test::Methods

  def app() App end
end

RSpec.configure { |c| c.include SinatraTestAppHelpers }

