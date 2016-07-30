require 'bundler'
# require 'haml'
require 'csv'
Bundler.require
require_relative 'models/model.rb'
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
    # unless params[:file] &&
    #        (tmpfile = params[:file][:tempfile]) &&
    #        (name = params[:file][:filename])
    #   @error = "No file selected"
    #   return haml(:upload)
    # end
    # STDERR.puts "Uploading file, original name #{name.inspect}"
    # while blk = tmpfile.read(65536)
    #   # here you would write it to its final location
    #   @raw_data = CSV.read(blk.inspect)
    # end
    # "Upload complete"
    @raw_data = CSV.read(params[:file][:tempfile])
    @processed_data = Analysis.new(@raw_data)
    erb :results
    # puts "below here"
    # print @raw_data
    # puts ""
    # puts @raw_data.count
    # puts @raw_data[0].count
    # puts @raw_data[1].count
    # puts @raw_data[2].count
    # puts @raw_data[3].count
    # puts @raw_data[4].count
    # puts @raw_data.each do |row|
    #   puts row.count
    # end
    # @nested_data = to_nested(@raw_data)
    # @nested_data.each do |row|
    #   print row
    #   puts ""
    # end
    # puts "above here"
    # @processed_data = Analysis.new(@raw_data)
    # erb :results
  end

end
