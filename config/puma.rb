# frozen_string_literal: true

require "barnes"
require "newrelic_rpm"

# Puma can serve each request in a thread from an internal thread pool. The
# `threads` method setting takes two numbers: a minimum and maximum. Any
# libraries that use thread pools should be configured to match the maximum
# value specified for Puma. Default is set to 5 threads for minimum and
# maximum; this matches the default thread size of Active Record.
threads_count = Integer(ENV.fetch("WEB_MAX_THREADS", 5))
threads(threads_count, threads_count)

# Puma 8 defaults the bind host to `::` (IPv6) when the machine has a
# non-loopback IPv6 interface. Pin IPv4 explicitly so what we bind does not
# depend on the host's interfaces.
port ENV.fetch("PORT", 5000), "0.0.0.0"

environment ENV.fetch("RACK_ENV", "development")

# Specifies the number of `workers` to boot in clustered mode. Workers are
# forked webserver processes. If using threads and workers together the
# concurrency of the application would be max `threads` * `workers`.
workers Integer(ENV.fetch("WEB_CONCURRENCY", 2))

# Settings that only mean anything with workers. Puma 8's `cluster` block runs
# after the config is loaded, so it is skipped entirely when WEB_CONCURRENCY is
# 0 and Puma stops warning that these hooks are unreachable.
cluster do
  # Boot the app before forking so workers share memory copy-on-write. This has
  # been the default since Puma 7; kept explicit as documentation.
  preload_app!

  # Start the Barnes agent in the master, before any workers are forked, so it
  # reports dyno metrics for the whole process tree.
  before_fork do
    Barnes.start
  end
end

# Allow puma to be restarted by `touch`-ing the `tmp/restart.txt` file.
plugin :tmp_restart
