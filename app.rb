require 'sinatra'
require 'erb'
require 'sass'
require 'active_support/all'
require 'sinatra/asset_pipeline'

Dir[File.join(Sinatra::Application.root, 'lib/**/*.rb')].each { |f| require f }

register Sinatra::AssetPipeline

configure do
  Sprockets::Helpers.configure do |config|
    config.debug = development?
  end
end

set :poster_path, 'public/images/posters'

get '/:poster' do
  catalog = Catalog.new(Poster.all(settings.poster_path))
  @poster = catalog.find_by_name(params[:poster])

  return status 404 unless @poster

  erb :poster
end

get '/' do
  catalog = Catalog.new(Poster.all(settings.poster_path))
  @poster = catalog.random

  erb :poster
end

module LinkHelpers
  def link_to_poster(poster, content, attrs)
    attributes = attrs.collect { |a, v| "#{a.to_s}='#{v.to_s}'" }.join(' ')
    %{<a href='/#{poster.name}' title='#{poster.title}' #{attributes} >#{content}</a>}
  end
end

helpers LinkHelpers
