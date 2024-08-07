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

port ENV.fetch("PORT", 5000)

environment ENV.fetch("RACK_ENV", "development")

# Specifies the number of `workers` to boot in clustered mode. Workers are
# forked webserver processes. If using threads and workers together the
# concurrency of the application would be max `threads` * `workers`.
workers Integer(ENV.fetch("WEB_CONCURRENCY", 2))

# Use the `preload_app!` method when specifying a `workers` number. This
# directive tells Puma to first boot the application and load code before
# forking the application. This takes advantage of Copy On Write process
# behavior so workers use less memory.
preload_app!

# If you are preloading your application and using Active Record, it's
# recommended that you close any connections to the database before workers
# are forked to prevent connection leakage.
before_fork do
  Barnes.start
end

# The code in the `on_worker_boot` will be called if you are using clustered
# mode by specifying a number of `workers`. After each worker process is
# booted, this block will be run. If you are using the `preload_app!` option,
# you will want to use this block to reconnect to any threads or connections
# that may have been created at application boot, as Ruby cannot share
# connections between processes.
on_worker_boot do
end

# Allow puma to be restarted by `touch`-ing the `tmp/restart.txt` file.
plugin :tmp_restart
