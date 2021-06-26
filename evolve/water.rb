class Water
  attr_accessor :symbol
  
  def initialize
    @symbol = "~"
    #puts "new water position"
  end
  
  def change_to_nothing
    @symbol = "."
  end
  
  def change_to_ice
    @symbol = "%"
  end
  
   def change_to_water
    @symbol = "~"
  end
  
end