require 'sinatra/base'
require 'sinatra/asset_pipeline'
require 'erb'
require 'sass'
require 'active_support/all'
require_relative 'lib/catalog'
require_relative 'lib/poster'

class App < Sinatra::Base

  configure do
    Sprockets::Helpers.configure do |config|
      config.debug = development?
    end
  end

  set :assets_css_compressor, :sass
  set :logging, true
  set :poster_path, 'public/images/posters'

  register Sinatra::AssetPipeline # must come after configuration

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

  run! if app_file == $0
end
