require 'bundler'
# require 'haml'
require 'csv'
require 'google/api_client/client_secrets'
require 'sinatra'
require 'logger'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

Bundler.require
require_relative 'models/model.rb'
require_relative 'models/model2.rb'



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

  # Goal here is to get the webapp to include authentication as a separate page, or as a step along the way.
  def user_credentials
    # Build a per-request oauth credential based on token stored in session
    # which allows us to use a shared API client.
    @authorization ||= (
      auth = settings.authorization.dup
      auth.redirect_uri = to('/oauth2callback')
      auth.update_token!(session)
      auth
    )
  end

  configure do

    Google::Apis::ClientOptions.default.application_name = 'APCS Webapp'
    Google::Apis::ClientOptions.default.application_version = '1.0.0'

    client_secrets = Google::APIClient::ClientSecrets.load
    authorization = client_secrets.to_authorization
    authorization.scope = 'https://www.googleapis.com/auth/calendar'

    set :authorization, authorization
    set :logger, logger
  end

  before do
    # Ensure user has authorized the app
    unless user_credentials.access_token || request.path_info =~ /^\/oauth2/
      redirect to('/oauth2authorize')
    end
  end

  after do
    # Serialize the access/refresh token to the session and credential store.
    session[:access_token] = user_credentials.access_token
    session[:refresh_token] = user_credentials.refresh_token
    session[:expires_in] = user_credentials.expires_in
    session[:issued_at] = user_credentials.issued_at
  end

  get '/oauth2authorize' do
    # Request authorization
    redirect user_credentials.authorization_uri.to_s, 303
  end

  get '/oauth2callback' do
    # Exchange token
    user_credentials.code = params[:code] if params[:code]
    user_credentials.fetch_access_token!
    redirect to('/')
  end

  get '/apcs' do
    erb :apcs
  end

  post '/quizcheck'do
    require_relative 'models/cs-quiz.rb'
    @metadata = get_metadata
    @raw_data = CSV.read(params[:file][:tempfile])
    push_assessment(@raw_data)
    erb :quizcheck
  end

end
