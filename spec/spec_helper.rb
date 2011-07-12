ENV['RACK_ENV'] = 'test'

require 'rack/test'
require_relative '../app.rb'

module RSpecMixinExample
  include Rack::Test::Methods

  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixinExample }

