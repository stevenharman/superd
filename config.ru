ENV["RACK_ENV"] ||= "development"

require_relative "app"

# Build the CSS once per boot so Sinatra serves it as a static file. Puma
# preloads the app, so this runs in the master before any worker forks.
# Development deliberately skips it and renders through the route instead.
App.stylesheets.precompile if App.production?

run(App)
