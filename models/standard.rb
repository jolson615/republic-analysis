class Standard
  attr_accessor :text, :questions
  @@list = []
  def initialize(text)
    @@list.push(self)
    @text = text
    @questions = []
  end

  def self.list
    @@list
  end

end
