require "active_support"
require "active_support/core_ext/integer/time"

# Marks fingerprinted assets as cacheable forever.
#
# The digest in the filename changes whenever the contents do, so a given URL
# can never serve different bytes, which is exactly the condition that makes
# `immutable` safe. Unfingerprinted files under public/ (posters, fonts, the
# favicon) are deliberately left alone and keep Sinatra's default handling.
#
# This has to be middleware rather than a `before` filter: Sinatra serves
# static files in `static!`, which halts before filters ever run.
class ImmutableAssets
  FINGERPRINTED = %r{\A/stylesheets/[\w-]+-\h{8}\.css\z}
  ONE_YEAR = Integer(365.days)

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    if status == 200 && FINGERPRINTED.match?(env["PATH_INFO"])
      headers["cache-control"] = "public, max-age=#{ONE_YEAR}, immutable"
    end

    [status, headers, body]
  end
end
