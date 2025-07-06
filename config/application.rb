# frozen_string_literal: true
require 'active_record'
require 'sqlite3'
require 'yaml'
require 'erb'

# This is some boilerplate code to read the config/database.yml file
# And connect to the database
config_path = File.join(__dir__, 'database.yml')
erb_template = File.read(config_path)
processed_yaml = ERB.new(erb_template).result
ActiveRecord::Base.configurations = YAML.load(processed_yaml)

# Use the appropriate environment
env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
puts "Connecting to database environment: #{env}"
ActiveRecord::Base.establish_connection(env.to_sym)

# Set a logger so that you can view the SQL actually performed by ActiveRecord
logger = Logger.new($stdout)
logger.formatter = proc do |_severity, _datetime, _progname, msg|
  "#{msg}\n"
end
ActiveRecord::Base.logger = logger

# Load all models!
Dir["#{__dir__}/../models/*.rb"].each { |file| require file }

