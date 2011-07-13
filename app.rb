require 'sinatra'
require 'erb'
require 'sass'
require 'compass'
require 'active_support/all'

Dir[File.join(Sinatra::Application.root, 'lib/**/*.rb')].each { |f| require f }

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views/stylesheets/'
    config.environment = Sinatra::Application.environment
  end

  set :scss, Compass.sass_engine_options
end

set :poster_path, 'public/images/posters'

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :'stylesheets/styles'
end

get '/:poster' do
  catalog = Catalog.new(Poster.all(settings.poster_path))
  @poster = catalog.find_by_name(params[:poster])

  return status 404 unless @poster

  erb :poster
end

get '/' do
  erb :index
end
