require 'google_drive'

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
session = GoogleDrive::Session.from_config("config.json")

ws = session.spreadsheet_by_key("1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs").worksheets[0]

$number_of_assessments = ws[1, 2].to_i
$number_of_students = ws[2, 2].to_i

def add_assessment(nested_data)
  puts nested_data
  puts nested_data.class
  puts nested_data.count
  #need to code in CREATING a new spreadsheet from here - not sure if possible.
  assessment = session.spreadsheet_by_key("1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs").worksheets[$number_of_assessments+2]
  nested_data.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      assessment = session.spreadsheet_by_key("1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs").worksheets[$number_of_assessments+2]
      assessment[x+1,y+1] = cell
    end
  end
end
