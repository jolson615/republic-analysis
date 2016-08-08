class Advisory
  attr_accessor :students, :name, :overall_average, :percent_grade_level, :bubble_students, :bubble_percent, :standards_hash, :standards_averages
  @@list = []
  def initialize(name)
    @name = name
    @standards_hash = {}
    @standards_averages = {}
    @students = []
    @@list.push(self)
    @bubble_students = []
    @grade_level_list = {
      :at => [],
      :above => [],
      :below => []
    }
    @percent_grade_level = {}
  end

  def self.list
    @@list
  end

  def compute_advisory_average
    raw_scores = []
    @students.each do |student|
      raw_scores.push(student.raw_score)
    end
    @overall_average = raw_scores.mean
  end

  def sort_students_by_grade_level
    @students.each do |student|
      if student.on_grade_level == "Below Grade Level"
        @grade_level_list[:below].push(student)
      elsif student.on_grade_level == "At Grade Level"
        @grade_level_list[:at].push(student)
      elsif student.on_grade_level == "Above Grade Level"
        @grade_level_list[:above].push(student)
      else
        puts "ERROR: #{student.name} doesn't have a grade level designation."
      end
    end
    @grade_level_list.each do |designation, student_list|
      @percent_grade_level[designation] = student_list.count.to_f / @students.count.to_f
    end
  end

  def compute_bubble_percent
    @students.each do |student|
      if student.raw_score.to_i > 59 && student.raw_score.to_i < 70
        @bubble_students.push(student)
      end
    end
    @bubble_percent = @bubble_students.count.to_f / @students.count.to_f
  end

  def compute_standards_performance
    @standards_hash.each do |standard, arr|
      @standards_averages[standard] = arr.mean
    end
  end

end
