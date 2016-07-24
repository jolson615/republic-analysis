require 'bundler'
Bundler.require
require_relative 'models/model.rb'

class MyApp < Sinatra::Base

  get '/' do
    erb :index
  end

  post '/results' do
    print params[:data]
    @processed_data = Analysis.new(params[:data])
    erb :results
  end

  get '/results' do
    erb :results
  end

end
