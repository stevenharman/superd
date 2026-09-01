require "pathname"
require "sinatra/base"
require "active_support/all"
require_relative "lib/catalog"
require_relative "lib/immutable_assets"
require_relative "lib/poster"
require_relative "lib/stylesheets"

class App < Sinatra::Base
  use ImmutableAssets

  set :stylesheet_source_path, Pathname(settings.root) / "assets" / "stylesheets"
  set :stylesheet_output_path, Pathname(settings.public_folder) / "stylesheets"
  set :scss,
    views: settings.stylesheet_source_path,
    silence_deprecations: Stylesheets::SILENCED_DEPRECATIONS

  set :logging, true
  set :poster_path, "public/images/posters"

  # Memoized so the manifest is read from disk once per process rather than
  # once per request.
  def self.stylesheets
    @stylesheets ||= Stylesheets.new(
      source_dir: settings.stylesheet_source_path,
      output_dir: settings.stylesheet_output_path
    )
  end

  # Only reached when there's no precompiled file in public/ - Sinatra checks
  # static files before routes, so production never gets here.
  get "/stylesheets/:sheet.css" do
    sheet = params[:sheet]
    pass unless /\A[\w-]+\z/.match?(sheet)
    pass unless (settings.stylesheet_source_path / "#{sheet}.css.scss").exist?

    scss :"#{sheet}.css"
  end

  get "/:poster" do
    catalog = Catalog.new(Poster.all(settings.poster_path))
    @poster = catalog.find_by_name(params[:poster])

    return status 404 unless @poster

    erb :poster
  end

  get "/" do
    catalog = Catalog.new(Poster.all(settings.poster_path))
    @poster = catalog.random

    erb :poster
  end

  module LinkHelpers
    def link_to_poster(poster, content, options = {})
      attributes = options.collect { |o, v| "#{o}='#{v}'" }.join(" ")
      %(<a href='#{url_to(poster: poster)}' title='#{poster.title}' #{attributes} >#{content}</a>)
    end

    def url_to(poster:)
      url("/#{poster.name}")
    end

    def stylesheet_path(name)
      App.stylesheets.path_for(name)
    end
  end

  helpers LinkHelpers
end
