require 'sinatra/base'
require 'sinatra/asset_pipeline'
require 'erb'
require 'sass'
require 'active_support/all'
require_relative 'lib/catalog'
require_relative 'lib/poster'

class App < Sinatra::Base
  set :assets_precompile, %w(stylesheets/app.css *.eot *.svg *.ttf *.woff *.otf)
  set :assets_css_compressor, :sass

  configure do
    Sprockets::Helpers.configure do |config|
      config.debug = development?
    end
  end

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
    def link_to_poster(poster, content, options = {})
      attributes = options.collect { |o, v| "#{o.to_s}='#{v.to_s}'" }.join(' ')
      url = url("/#{poster.name}")
      %{<a href='#{url}' title='#{poster.title}' #{attributes} >#{content}</a>}
    end
  end

  helpers LinkHelpers

  run! if app_file == $0
end
