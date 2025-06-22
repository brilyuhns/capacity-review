require 'sinatra'
require 'sassc'
require './app'
require './app/controllers/projects_controller'
require './app/controllers/capacities_controller'
require './app/controllers/project_allocations_controller'
require './app/controllers/analytics_controller'
use Rack::MethodOverride
# Sass
template = File.read('stylesheets/style.scss')

options = { style: :compressed,
            filename: 'style.scss',
            output_path: 'style.css',
            source_map_file: 'style.css.map',
            load_paths: ['stylesheets'],
            source_map_contents: true }

engine = SassC::Engine.new(template, options)

css_content = engine.render
File.write('public/css/style.css', css_content)

map = engine.source_map
File.write('public/css/style.css.map', map)

# run App

# # Mount the controllers
map('/') { run App }
map('/projects') { run ProjectsController }
map('/capacities') { run CapacitiesController }
map('/project_allocations') { run ProjectAllocationsController }
map('/analytics') { run AnalyticsController }