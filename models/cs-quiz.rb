require_relative 'drive_api_auth.rb'

# Initialize the API
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

# abandoning this api for a while to go back to the ruby library we found - I think it will work better.
