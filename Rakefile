require 'sinatra/asset_pipeline/task'
require_relative 'app'

Sinatra::AssetPipeline::Task.define! App

begin
  require 'rspec/core/rake_task'
  task default: :spec

  desc 'Run those specs'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end
