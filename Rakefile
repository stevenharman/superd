require_relative "app"

namespace :assets do
  desc "Compile stylesheets into public/ for static serving"
  task :precompile do
    App.stylesheets.precompile.each { |path| puts "compiled #{path}" }
  end

  desc "Remove compiled stylesheets from public/"
  task :clean do
    App.stylesheets.clean.each { |path| puts "removed #{path}" }
  end
end

begin
  require "rspec/core/rake_task"
  task default: :spec

  desc "Run those specs"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end
