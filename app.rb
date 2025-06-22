require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require './helpers'
require 'securerandom'

# Load all models
Dir[File.join(File.dirname(__FILE__), 'app', 'models', '*.rb')].each { |file| require file }

class App < Sinatra::Base
  configure do
    enable :sessions
    set :json_encoder, :to_json
    set :erb, layout: :layout
    set :public_folder, File.join(File.dirname(__FILE__), 'public')
  end

  before do
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
  end

  options '*' do
    response.headers['Allow'] = 'HEAD,GET,PUT,DELETE,OPTIONS,POST'
    response.headers['Access-Control-Allow-Headers'] =
      'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  end

  get '/' do
    erb :index
  end
end