require 'sinatra'
require 'erb'
require 'sass'
require 'compass'

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views/stylesheets/'
    config.environment = :production if ENV['RACK_ENV'] == 'production'
  end

  set :scss, Compass.sass_engine_options
end

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :'stylesheets/styles'
end

get '/' do
  erb :index
end
