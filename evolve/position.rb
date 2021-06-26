require_relative "water"
require_relative "earth"

class Position
  attr_accessor :state, :type, :symbol, :fneighbours, :sneighbours, :x, :y, :contents, 
                         :temperature, :water_content, :water_bank, :group

  def initialize
    @state = 'vacant'
	@type = ' '
    @symbol = ' '
    @fneighbours = []
	@sneighbours = []
	@contents = []
	@temperature = 10
	@water_content = 0
	@water_bank = 0
	@group = 0
  end
  
  def create_position(type,x,y)
    if type == "water"
	  @type = Water.new
	  @temperature = 20 + rand(1..5)
	  @water_content = 100
	  @group = 1
	elsif type == "earth"
	  @type = Earth.new
	  @temperature = 20 + rand(1..5)
	  @water_content = 80 #+ rand(1..20)
	  @group = 0
	end
	@symbol = @type.symbol
	@x = x
	@y = y
	
	self
  end
  
    def create_position_copy(type,pos)
    if type == "water"
	  @type = Water.new
	elsif type == "earth"
	  @type = Earth.new
	end
	@symbol = @type.symbol
	@x = pos.x
	@y = pos.y
	@state = pos.state
	@fneighbours = pos.fneighbours
	@sneighbours = pos.sneighbours
	@contents = pos.contents
	@temperature = pos.temperature
	@water_content = pos.water_content
	@water_bank = pos.water_bank
	@group = pos.group
	
	self
  end
  
  
end