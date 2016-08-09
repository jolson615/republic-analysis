require 'bundler'
# require 'haml'
require 'csv'
Bundler.require
require_relative 'models/model.rb'


class MyApp < Sinatra::Base

  get '/' do
    erb :index
  end

  post '/results' do
      @raw_data = CSV.read(params[:file][:tempfile])
      @processed_data = Analysis.new(@raw_data)
      erb :results
  end

  get '/results' do
    erb :results
  end

  # post '/test' do
  #   @raw_data = CSV.read(params[:file][:tempfile])
  #   @processed_data = Analysis.new(@raw_data)
  #   erb :results
  # end
  #
  # post '/refactor' do
  #   @raw_data = CSV.read(params[:file][:tempfile])
  #   @processed_data = Analysis.new(@raw_data)
  #   erb :results2
  # end

  # Goal here is to get the webapp to include authentication as a separate page, or as a step along the way.
  get '/apcs' do
    erb :apcs
  end

  post '/quizcheck'do
    require_relative 'models/model2.rb'
    require_relative 'models/cs-quiz.rb'
    @metadata = get_metadata
    @raw_data = CSV.read(params[:file][:tempfile])
    push_assessment(@raw_data)
    erb :quizcheck
  end

end
