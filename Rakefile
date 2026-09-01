require_relative "app"

begin
  require "rspec/core/rake_task"
  task default: :spec

  desc "Run those specs"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end
