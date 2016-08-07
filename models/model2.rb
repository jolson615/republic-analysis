require_relative 'advisory.rb'
require_relative 'question.rb'
require_relative 'standard.rb'
require_relative 'student.rb'

class Analysis
  attr_reader :nested_data, :row_count, :col_count, :student_count, :question_count, :standards, :advisories, :answer_key, :students, :weights_array
  def initialize(raw_data)
    # Control flow to handle CSV or Text input
    if raw_data.class == String #text input
      clean_data = raw_data.gsub("\"","")
      @nested_data = clean_data.split("\r\n").collect do |row|
        row.split("\t")
      end
    else #CSV input
      @nested_data = raw_data
    end
    # Validate the myriad different advisory names.
    clean_advisory_names
    @row_count = @nested_data.count
    @col_count = @nested_data[0].count
    @student_count = @row_count - 3
    @question_count = @col_count - 5
    @standards = []
    populate_standards
    @advisories = []
    populate_advisories
    @questions = []
    populate_questions
    @students = []
    populate_students
    # Still need to calculate scores, averages, and populate questions
  end

  def populate_students
    @student_count.times do |i|
      @students.push(Student.new(@nested_data[i+3]))
    end
  end

  def populate_standards
    @question_count.times do |i|
      @standards << @nested_data[1][i+5]
    end
    @standards.uniq.each do |text|
      Standard.new(text)
    end
    @standards = Standard.list
  end

  def populate_questions
    @question_count.times do |i|
      j = i+5
      @questions.push(Question.new(j, @nested_data[1][j], @nested_data[2][j]))
    end
  end

  def populate_advisories
    @advisories.push("All students")
    @nested_data.each_with_index do |row, row_number|
      #validate advisory (slice off " House")
      # this_advisory = row[2].gsub(" House", "")
      unless row_number < 3 || @advisories.include?(row[2])
        @advisories.push(row[2])
      end
    end
    @advisory_list = []
    @advisories.each do |advisory|
      @advisory_list.push(Advisory.new(advisory))
    end
    @advisories = @advisory_list
  end
end
