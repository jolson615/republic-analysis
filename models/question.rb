class Question
  attr_accessor :number, :standard, :correct_answer
  @@list = []
  def initialize(number, std_text, correct_answer)
    @number = number
    Standard.list.each do |standard|
      if standard.text == std_text
        @standard = standard
      end
    end
    # @standard = Standards.list()
    @correct_answer = correct_answer
    @@list.push(self)
  end

  def self.list
    @@list
  end
end
