require "sinatra/base"
require "active_support/all"
require_relative "lib/catalog"
require_relative "lib/poster"

class App < Sinatra::Base
  # Bourbon 4 and Font Awesome 4 predate modern Dart Sass; silence the
  # deprecations they trip so real warnings stay visible. Revisit if/when
  # those vendored stylesheets are upgraded.
  set :scss,
    views: File.join(settings.root, "assets", "stylesheets"),
    silence_deprecations: %w[color-functions elseif global-builtin if-function import slash-div]

  set :logging, true
  set :poster_path, "public/images/posters"

  get "/stylesheets/:sheet.css" do
    sheet = params[:sheet]
    pass unless /\A[\w-]+\z/.match?(sheet)
    pass unless File.exist?(File.join(settings.scss[:views], "#{sheet}.css.scss"))

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
  end

  helpers LinkHelpers
end
