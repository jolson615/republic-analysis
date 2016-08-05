class Advisory
  attr_accessor :students, :name
  @@list = []
  def initialize(name)
    @name = name
    @students = []
    @@list.push(self)
    @bubble_students = []
  end

  def self.list
    @@list
  end

end
