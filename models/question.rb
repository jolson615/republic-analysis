class Question
  attr_accessor :number, :standard, :correct_answer, :answers_by_advisory, :mastery_by_advisory
  @@list = []
  def initialize(number, std_text, correct_answer)
    @number = number.to_i
    Standard.list.each do |standard|
      if standard.text == std_text
        @standard = standard
        standard.questions.push(self)
        puts "Question #{self.number} sorted into standard: #{standard.text}"
      end
    end
    # @standard = Standards.list()
    @correct_answer = correct_answer
    @answers_by_advisory = {}
    @mastery_by_advisory = {}
    @@list.push(self)
  end

  def self.list
    @@list
  end

end
