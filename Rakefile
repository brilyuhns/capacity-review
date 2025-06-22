require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

# Load the app
require_relative 'app'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require_relative 'config/application'

# Load all tasks
Dir.glob('lib/tasks/*.rake').each { |r| load r }

# Set up database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/app.sqlite3'
)

namespace :db do
  task :environment do
    # Set up database connection
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'db/app.sqlite3'
    )
  end
end

desc 'Look for style guide offenses in your code'
task :rubocop do
  sh 'rubocop --format simple || true'
end

task default: %i[rubocop spec]

desc 'Open an irb session preloaded with the environment'
task :console do
  require 'rubygems'
  require 'pry'

  Pry.start
end