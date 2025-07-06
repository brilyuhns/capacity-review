require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

# Load the app
require_relative 'app'

# Only load RSpec tasks if RSpec is available (development/test environments)
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # RSpec not available, skip loading RSpec tasks
end

require_relative 'config/application'

# Load all tasks
Dir.glob('lib/tasks/*.rake').each { |r| load r }

# Database connection is now handled by config/application.rb

namespace :db do
  task :environment do
    # Database connection is handled by config/application.rb
  end
end

desc 'Look for style guide offenses in your code'
task :rubocop do
  sh 'rubocop --format simple || true'
end

# Only set spec as default task if RSpec is available
if defined?(RSpec)
  task default: %i[rubocop spec]
else
  task default: %i[rubocop]
end

desc 'Open an irb session preloaded with the environment'
task :console do
  require 'rubygems'
  require 'pry'

  Pry.start
end