require 'bundler'
# require 'haml'
require 'csv'
Bundler.require
require_relative 'models/model.rb'
require_relative 'models/model2.rb'
require_relative 'models/csv-converter.rb'

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

  post '/test' do
    @raw_data = CSV.read(params[:file][:tempfile])
    @processed_data = Analysis.new(@raw_data)
    erb :results
  end

  post '/refactor' do
    @raw_data = CSV.read(params[:file][:tempfile])
    @processed_data = Analysis.new(@raw_data)
    erb :results2
  end

end
