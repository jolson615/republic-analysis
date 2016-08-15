require 'csv'
require 'open-uri'

class Array #adds a mean function to Arrays, if contents of array are
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean
    sum / size.to_f
  end
end



class Item
  attr_reader :assessment_number, :question, :standard, :score, :weight, :student_email
  @@list = []
  def initialize(assessment_number, question, standard, score, weight, student_email)
    @assessment_number = assessment_number
    @question = question
    @standard = standard
    @score = score
    @student_email = student_email
    @weight = weight
    @@list << self
  end

  def self.list
    @@list
  end

end



def parse_into_items(assessment, assessment_number)
  if assessment.count > 3
    #parse list into items, where assessment is a nested array, and assessment number is hardcoded.
    number_of_questions = assessment[0].count - 3
    number_of_students = assessment.count - 3
    number_of_questions.times do |i|
      number_of_students.times do |j|
        x= i+3 # starts at third column
        y= j+3 # starts at third row
        assessment_number = assessment_number.to_i #already defined - converting to integer for safety.
        question = assessment[0][x] #pulls the xth item from the question row.
        # q is a string
        standard = assessment[1][x] #pulls the xth item from the standard row DEFINED MANUALLY
        # std is a string
        score = (assessment[y][x].to_f)/(assessment[2][x].to_f)
        # score is a float between 0 and 1 - does not weight questions because from one day to another, that wouldn't make sense.
        student_email = assessment[y][0]
        weight = assessment[2][x].to_i
        #push item to master list of all items
        Item.new(assessment_number, question, standard, score, weight, student_email)
        # @item_list.push(Item.new(assessment_number, question, standard, score, student_email))
      end
    end
  else
    puts "Assessment #{assessment_number} has insufficient data"
  end
  return Item.list
end

# Eventually must automate these lines of code, but hardcoded until I can write a script to snatch the GIDs
# Assessment 1
def temporary_fetch
  url = "https://docs.google.com/spreadsheets/d/1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs/pub?gid=2114410807&single=true&output=csv"
  data1 = CSV.parse(open(url).read)
  parse_into_items(data1, 1)

  # Assessment 2
  url = "https://docs.google.com/spreadsheets/d/1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs/pub?gid=1657164873&single=true&output=csv"
  data1 = CSV.parse(open(url).read)
  parse_into_items(data1, 2)

  # Assessment 3
  url = "https://docs.google.com/spreadsheets/d/1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs/pub?gid=1278939598&single=true&output=csv"
  data1 = CSV.parse(open(url).read)
  parse_into_items(data1, 3)

  # Assessment 4
  url = "https://docs.google.com/spreadsheets/d/1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs/pub?gid=397189839&single=true&output=csv"
  data1 = CSV.parse(open(url).read)
  parse_into_items(data1, 4)

  # Assessment 5
  url = "https://docs.google.com/spreadsheets/d/1woXBbju2J6lYU5nKFKDU3nBySgKW9MWP_vEkG7FsnWs/pub?gid=13824931&single=true&output=csv"
  data1 = CSV.parse(open(url).read)
  parse_into_items(data1, 5)

  return Item.list
end

# store metadata and results in this object
class IndividualResults
  attr_reader :standard_list, :student_list, :standard_list, :tables
  def initialize(item_list)
    @item_list=item_list
    @tables = {} #this will be hash where each standard is keyed to a 2D array.
    list_standards
    list_students
    create_results
  end

  def list_standards # This is inefficient, but will help if we need to refactor later.
    @standard_list = []
    @item_list.each {|item| @standard_list.push(item.standard)}
    @standard_list = @standard_list.uniq
  end

  def list_students
    @student_list = []
    @item_list.each {|item| @student_list.push(item.student_email)}
    @student_list = @student_list.uniq
  end

  def create_results
    @standard_list.each do |standard|
      #create list of assessments on which this standard has been assessed
      test_list = []
      @item_list.each do |item|
        if item.standard == standard
          test_list.push(item.assessment_number)
        end
      end

      @tables[standard] = []
      # The following code line actually makes the ERB a lot more complicated. But it's useful for parsing the code below.
      # General format for each row in a table is as follows:
      # @tables[standard].push(["Student", "Initial Attempt", "Prior Attempt", "Most Recent Attempt", "growth"])
      #Begin wrapper to define rows. Using students for now, but this is easily changed.
      @student_list.each do |student_email|
        test_list = test_list.sort.uniq
        the_big_three = {test_list[0] => [],test_list[-2] => [],test_list[-1] => []}
        #BEGIN codeblock to create results
        @item_list.each do |item|
          if item.standard == standard && the_big_three.key?(item.assessment_number) && student_email == item.student_email
            item.weight.times do # pushes an item weighted 3x into the array three times.
              the_big_three[item.assessment_number].push(item.score) # stores all scores keyed to first, second most recent, and most recent attempts.
            end
          end
        end
        # END codeblock to create results
        puts the_big_three
        scores = the_big_three.values.collect {|arr| arr.mean}
        # create row for student
        puts scores
        if scores.count == 1
          growth = "n/a"
        elsif scores.count == 2
          growth = scores[1]-scores[0]
        else
          growth = scores[2]-scores[0]
        end
        new_row = [student_email, scores[0], scores[1], scores[2], growth]
        # push the row
        @tables[standard].push(new_row)
      end
    end
  end

  #end of IndividualResults class
end
