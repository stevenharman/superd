require 'sinatra/asset_pipeline/task'
require_relative 'app'

Sinatra::AssetPipeline::Task.define! App

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  desc 'Run those specs'
  task :spec do
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.pattern = 'spec/**/*_spec.rb'
    end
  end

  task default: :spec
end
