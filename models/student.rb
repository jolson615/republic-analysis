class Student
  attr_reader :answers, :name, :advisory, :on_grade_level
  attr_accessor :raw_score, :standards_breakdown, :score_array
  @@list = []
  def initialize(student_row)#, weights_array=Analysis.weights_array)
    @student_row = student_row
    @name = student_row.shift
    @student_id = student_row.shift
    @advisory = student_row.shift
    @raw_score = student_row.shift
    @on_grade_level = student_row.shift
    @answers = student_row
    @@list.push(self)
    #@weights_array = weights_array
  end

  def self.count
    @@list.count
  end

  def self.list
    @@list
  end

end
