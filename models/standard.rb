class Standard
  attr_accessor :text
  @@list = []
  def initialize(text)
    @@list.push(self)
    @text = text
  end

  def self.list
     @@list
  end

end
