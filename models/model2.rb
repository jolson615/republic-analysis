require_relative 'advisory.rb'
require_relative 'question.rb'
require_relative 'standard.rb'
require_relative 'student.rb'

class Analysis
  attr_reader :nested_data, :row_count, :col_count, :student_count, :question_count, :standards, :advisories, :answer_key, :students, :weights_array, :questions
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
    # Still need to calculate scores, averages, and populate questions with data.s
    compute_advisory_averages
    process_student_answers
  end

  def process_student_answers
    # log the answers
    @students.each do |student|
      @questions.each do |question|
        unless question.answers_by_advisory[student.advisory]
          question.answers_by_advisory[student.advisory] = []
        end
        question.answers_by_advisory[student.advisory].push(student.answers[question.number.to_i - 1])
      end
    end
    # compute the answers
    @questions.each do |question|
      question.answers_by_advisory.each do |advisory, answers|
        question.mastery_by_advisory[advisory] = ((answers.mean * 100).to_i.to_f)/100
      end
    end
  end

  def compute_advisory_averages
    @advisories.each do |advisory|
      advisory.compute_advisory_average
      advisory.sort_students_by_grade_level
      advisory.compute_bubble_percent
    end
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
      @questions.push(Question.new(i+1, @nested_data[1][j], @nested_data[2][j]))
      puts @questions[i].number
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
    @advisories.each do |advisory|
      @standards.each do |standard|
        advisory.standards_hash[standard] = []
      end
    end
  end

  def clean_advisory_names
    @nested_data.count.times do |i|
      if @nested_data[i][2]
        @nested_data[i][2] = @nested_data[i][2].gsub(" House", "").gsub("DuBois", "Du Bois")
      end
    end
  end
end

class Array #adds an averaging method for the Array class
  def sum
    inject(0.0) { |result, el| result.to_f + el.to_f }
  end

  def mean
    sum / size
  end
end
