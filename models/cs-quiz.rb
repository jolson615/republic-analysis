require_relative 'drive_api_auth.rb'
require 'net/http'
require 'uri'

def get_metadata
  service = Google::Apis::SheetsV4::SheetsService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize
  spreadsheet_id = '1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs'
  range = 'metadata!a1:b2'
  response = service.get_spreadsheet_values(spreadsheet_id, range) # returns an object. Use the .values to access the arrays.
  puts response.class
  puts response.values.class
  puts response.values.count
  puts response.values[0].class
  return response
end

class Numeric
  Alph = ("A".."Z").to_a
  def alph
    s, q = "", self
    (q, r = (q - 1).divmod(26)) && s.prepend(Alph[r]) until q.zero?
    s
  end
end

def push_assessment(raw_data)
  # measures the area of the assessment data for the API
  final_col = (raw_data[0].count).alph #converts 3 to C, 27 to AA etc. based on number of columns
  final_row = raw_data.count #counts number of rows.
  @metadata = get_metadata.values
  @number_of_assessments = @metadata[0][1].to_i
  @number_of_students = @metadata[1][1].to_i

  # New instance of the API, as it doesn't persist from the metadata call yet.
  service = Google::Apis::SheetsV4::SheetsService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize

  # Since I can't figure out how to create the object from scratch, we're just going to call one up and modify it.
  spreadsheet_id = '1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs'
  range = 'metadata!a1:b2'
  # This next line returns a skeleton of a Google Sheets object
  response = service.get_spreadsheet_values(spreadsheet_id, range)
  response.range = "#{@number_of_assessments+1}!a1:#{final_col}#{final_row}" #interpolates the range.
  range = response.range #matches the range for the ruby method.
  # Next line swaps out the dummy array for the real assessment data.
  response.values = raw_data
  service.update_spreadsheet_value(spreadsheet_id, range, response, value_input_option: "RAW")

  # Update the quiz count - same process as above, but with only one modification.
  range = 'metadata!a1:b2'
  response = service.get_spreadsheet_values(spreadsheet_id, range)
  updated_data = response.values
  updated_data[0][1] = (updated_data[0][1].to_i + 1).to_s
  response.values = updated_data
  response.range = range # fixes some weird capitalization validation mumbo jumbo
  service.update_spreadsheet_value(spreadsheet_id, range, response, value_input_option: "RAW")
end


# abandoning this api for a while to go back to the ruby library we found - I think it will work better.
