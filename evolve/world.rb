require_relative "position"
require_relative "log"

class World
  attr_accessor :positions, :width, :height, :sun_location, 
                         :interval, :logger, :log, :snow_count, :rain_count,
						 :show_weather, :water_groups, :day
  
  # initial settings for the world
  def initialize
    @day = 
    @interval = 1
  
    @positions = []
	@width = 24
	@height = 20
	@sun_location = 1
	@snow_count = 0
	@rain_count = 0
	@show_weather = true
	@water_groups = [1]

	@logger = Log.new
	if @log == true
	  
	  @logger.write "started"
	end
  end
  
  # create a world, it positions
  def create_world
    count = 1
    @height.times do |j|
      @width.times do |i|
	    #this creates half water and half earth positions
	    create_position("water", i + 1, j + 1) if (count <= ((@width*@height) / 2))
		create_position("earth", i + 1, j + 1) if (count  > ((@width*@height) / 2))
		#create_position("earth", i + 1, j + 1)
		count += 1
      end
    end
	if @log == true
	  @logger.write "created world"
	end
  end
  
  # create a new position by type
  def create_position(type,x,y)
    position = Position.new
    @positions << position.create_position(type,x,y) if type == "water"
    @positions << position.create_position(type,x,y) if type == "earth"
	if @log == true
	  @logger.write "created position"
	end
  end
  
  # display in detail information about the world positions
  def show
    @positions.each do |p|
	  puts p.inspect
	end
  end
  
  # display the "world"
  # print all the positions symbols, showing what the position is, and its state and occupants
  def paint_world
    show_sun
	puts ''
    count = 0
    @height.times do
      @width.times do
        print @positions[count].symbol
        count += 1
      end
      puts ''
    end
    puts '------------'
  end
  
  def paint_world2
    show_sun
	puts ''
    count = 0
    @height.times do
      @width.times do
        if @positions[count].type.class.to_s == "Water"
		  print @positions[count].group
		else
		  print @positions[count].symbol
		end
        #@positions[count].fneighbours = []
		#@positions[count].sneighbours = []
        count += 1
      end
      puts ''
    end
    puts '------------'
  end
  
  #this is suppossed to show the inhabitable and the uninhabitable posittions
  # inhabitable is temperature grater than -10 and less than 60
  # needs improvement and refinement
  def paint_world3
    show_sun
	puts ''
    count = 0
	x_count = 0
	h_count = 0
    @height.times do
      @width.times do
        #print @positions[count].symbol
		if @positions[count].temperature > -10 && @positions[count].temperature < 60
		  print "h" 
		  h_count += 1
		else
		  print "x" 
		  x_count += 1
		end
        #@positions[count].fneighbours = []
		#@positions[count].sneighbours = []
        count += 1
      end
      puts ''
    end
    puts '------------'
	[h_count,x_count]
  end
  
  # displays the symbol of the position
  def paint_world4
    show_sun2
	@logger.write("") # puts ''
    count = 0
    @height.times do
      @width.times do
        @logger.pwrite("#{@positions[count].symbol}") # print @positions[count].symbol
        count += 1
      end
      @logger.write("") # puts ''
    end
    @logger.write("") # puts '------------'
  end
  
  # change the cun location
  # increasing the temperature where the sun is shining
  # decreasing the temperature where the sun is not shining 
  def move_sun
	if @sun_location < @width
	  @sun_location += 1 
	else
	  @sun_location = 1 
	end
	
    ss = sun_locations @sun_location	
	
	increase_temperature(@sun_location,ss)
	decrease_temperature(@sun_location,ss)

	if @log == true
	  @logger.write "moved sun"
	end
  end
  
  # display the sun locations
  def show_sun
	ss = sun_locations @sun_location	
	
	@width.times do |i|
	  if ss.include?(i+1)
        print "\""
	  elsif (i+1) == @sun_location
	    print "*"
	  else
	    print "_"
	  end
	end
	print " --- day #{@day}"
  end
  # method for the logger
  def show_sun2
	ss = sun_locations @sun_location	
	
	@width.times do |i|
	  if ss.include?(i+1)
        @logger.pwrite("\"") # print "\""
	  elsif (i+1) == @sun_location
	    @logger.pwrite("*") # print "*"
	  else
	    @logger.pwrite("_") # print "_"
	  end
	end
  end
  
  # calculating the locations of the sun
  def sun_locations(loc)
    range = (@width / 4) - 1
    loc1 = loc - range
	loc2 = loc + range
	loc1 = (@width + loc1) if loc1 < 1
	loc2 = loc2 - @width if loc2 > @width
    #puts ""
	#puts loc1
	#puts loc
	#puts loc2
	
	#t = [loc1,loc2]
	
	ss = []
	if loc1 < @sun_location
	  [*loc1...(@sun_location)].each do |k|
	    ss << k
	  end
	elsif (@sun_location+1) < loc1
	  [*loc1..@width].each do |k|
	    ss << k
	  end
	  [*1..(@sun_location-1)].each do |k|
	    ss << k
	  end
	end
	
	if @sun_location < loc2
	  [*(@sun_location+1)..loc2].each do |k|
	    ss << k
	  end
	elsif loc2 < @sun_location
	  [*1..loc2].each do |k|
	    ss << k
	  end
	  [*(@sun_location+1)..@width].each do |k|
	    ss << k
	  end
	end
	#puts ss
	ss
  end
  
  def increase_temperature(loc,ss)
	inc = 20 # 4 # @width/5
	# inc = 1 if p.type.class.to_s == "Water"
	
	@positions.each do | p |
	  if ss.include?(p.x)
	    # shadows from cloud coverage, affecting sun light strength
	    inc = shadows(p,inc)
	    p.temperature += inc  + rand(1..3)#/2 #if p.temperature < 100
	  elsif p.x == @sun_location
	    # shadows from cloud coverage, affecting sun light strength
	    inc = shadows(p,inc)
	    p.temperature += (inc*2) + rand(1..3) #if p.temperature < 100
	  end
	  
	  # change ice to water
	  p.type.change_to_water if p.temperature >= 10 && p.type.class.to_s == "Water"
	  #change water to nothing, or a dry spot, which should maybe become earth
	  p.type.change_to_nothing if p.water_content < 1 && p.type.class.to_s == "Water"
	  
	  # if the temperature increases so does the rate of evaporation
	  if p.temperature < 10 && p.water_content > 1 #p.temperature > 0 && 
	    p.water_content -= 1
		p.water_bank += 1
	  elsif p.temperature > 10 && p.temperature < 20 && p.water_content > 2
	    p.water_content -= 2
		p.water_bank += 2
      elsif p.temperature > 20 && p.temperature < 40 && p.water_content > 4
	    p.water_content -= 4
		p.water_bank += 4
	  elsif p.temperature > 40 && p.temperature < 100 && p.water_content > 10
	    p.water_content -= 10
		p.water_bank += 10
	  elsif p.temperature > 100 && p.water_content > 20
	    p.water_content -= 20
		p.water_bank += 20
	  end
	end
  end

  def shadows(p,inc)
    # shadows from cloud coverage, affecting sun light strength
	if p.water_bank > 0 && p.water_bank < 4
	  # light clouds, magnifies the sun
	  # temperature increases
	  inc += 5
	elsif p.water_bank > 4 && p.water_bank < 10
	  # heavey cloud cover, sun light is diminshed
	  # temperature decreases
	  inc -= 3
	elsif p.water_bank > 10 && p.water_bank < 20
	  # temperature decreases
	  inc -= 5
	end
	# not sure why this, probably to fixe some kind of low temperature error
	# probably causing the positions to become to cold
	inc = 1 if inc < 0
	inc
  end
  
  def decrease_temperature(loc,ss)
	dec = 1 # rand(1..2) # 
	
	@positions.each do | p |
	  if !ss.include?(p.x)
	    p.temperature -= dec #if p.temperature > -10
		p.type.change_to_ice if p.temperature <= -10 && p.type.class.to_s == "Water"
	  end
	end
  end
  
  def weather
    @positions.each_with_index do | p,index |
	  if p.water_bank >= 20 && p.temperature > 0
		rain p
	  elsif p.water_bank >= 15 && p.temperature < 1
	    snow p
	  else
	  # chaning states, or types
	  # !!! NOTE this should be done somewhere else
	    if (p.water_content > 50 && p.water_content < 90) && p.type.class.to_s == "Earth"
		  p.type.change_to_mud 
		elsif p.water_content > 90 && p.type.class.to_s == "Earth"
		  #p.type.change_to_water
		  pos = Position.new
		  @positions[index] = pos.create_position_copy("water",p)
		  
		  group_water(@positions[index],index)
		elsif p.water_content < 50 && p.type.class.to_s == "Earth"
		  # change mud back to earth
		  p.type.change_to_earth
		else
		  
		end
		p.symbol = p.type.symbol
	  end
	  #possibly the wrong place to group the waters
	  #group_water(p,index) if p.type.class.to_s == "Water"
	end
  end
  
  # if water bank reaches 10 it rains
  def rain position
		# raining
		position.water_content += 8
		position.water_bank -= 8
		
		if position.temperature > 10
		  if position.type.class.to_s == "Water"
		    position.temperature -= 1
		  else
		    position.temperature -= 3
		  end
		else
		  position.temperature += 1 
		end
		#position.temperature += 10 if position.temperature < 1
		
		if @show_weather
		  position.symbol = 'r'
		end
		@rain_count += 1
		if @log == true
		  @logger.write "rained"
		end
  end
  
  def snow position
	    # snowing
	    position.water_content += 5
		position.water_bank -= 5
		
		if position.temperature > -100
		  if position.type.class.to_s == "Water"
		    position.temperature -= 3
		  else
		    position.temperature -= 5
		  end
		end
		
		if @show_weather
		  position.symbol = 's'
		end
		@snow_count += 1
		if @log == true
		  @logger.write "snowed"
		end
  end
  
  ## THIS WIND METHOD SEEMS WRONG !!!!!  
  # finds the coldest and the hottest positions
  # rearranges the water banks 
  # taking the coldest and placing it in the hottest position
  # and folowing the order
  # temperature should also drop with wind
  def wind
	coldest = 1000
	ci = 0
	warmest = -1000
	wi = 0
	## find the coldest and the hottest positions indexes
	@positions.each_with_index do |p,index|
	  if p.temperature < coldest
	    coldest = p.temperature
		ci = index
	  end
	  if p.temperature >= warmest
	    warmest = p.temperature
		wi = index
	  end
	end
	## puts "#{coldest} : #{ci}"
	## puts "#{warmest} : #{wi}"
	
	@positions[ci].temperature += 10
	
	
	##################################
	# left_over = @positions[ci].water_bank % 9
	# amount_for_each = @positions[ci].water_bank / 9
	n = check_neighbours(ci)
	n.each_with_index do |ni,index|
	  ni.temperature += 2
	  # ni.water_bank += amount_for_each  
	  # @positions[ci].water_bank -= amount_for_each  
	end
	
	@positions[wi].temperature -= 10
	# left_over = @positions[wi].water_bank % 9
	# amount_for_each = @positions[wi].water_bank / 9
    n = check_neighbours(wi)
	n.each_with_index do |ni,index|
	  ni.temperature -= 2
	  # ni.water_bank += amount_for_each  
	  # @positions[wi].water_bank -= amount_for_each  
	end
	####################################
	
	# gets the water banks, starting from the coldest
	start = ci
	s = []
	#from coldest position to last position
	[*start...(@width*@height)].each do |i|
	  s << @positions[i].water_bank
	end
	# from 0 (or first position) to the coldest position
	if start > 0
	  [*0..(start-1)].each do |i|
	    s << @positions[i].water_bank
	  end
	end
	
	# then starting fromt he warmest replacing the water banks with the previously collected
	start = wi
	#from warmest position to last position
	[*start...(@width*@height)].each do |i|
	  @positions[i].water_bank = s[i]
	end
	# from first position to warmest position
	if start > 0
	  [*0..(start-1)].each do |i|
	    @positions[i].water_bank = s[i]
	  end
	end
	
	if @log == true
	  @logger.write "wind"
	end
  end
  
  # calculate the total amount of water in the world
  # counts both the water content and water bank
  def total_water
    t = 0
    @positions.each_with_index do | p,index |
	  t += p.water_content
	  t += p.water_bank
	end
	t
  end
  
  # still under construction
  # it should assign the group with the most positions() ie the largest water group neighbour
  # at the momnet it assigns it the first water neighbours group
  def group_water(p,loc)
    n = check_neighbours(loc)
	g = -1
	
	n.each_with_index do |ni,index|
	  if ni.type.class.to_s == "Water"
	    g = index
	    break
	  else
	    g = -1
	  end
	end
	
	if g > -1
	  p.group = n[g].group
	else
	  p.group = @water_groups.max + 1
	  @water_groups << p.group
	end
  end
  
  # the equalization or leveling of water mass(es)
  # if water removed from any positions. Then the
  # remain water in the water mass is equally divided
  # among all the positions in the water mass
  def equalize_water
    # get groups
	groups = @positions.map {|x| x.group }
	groups.uniq!
	
	# calculate sum of water content for each group
    groups.each do |group|
	  sum = 0
	  count = 0
	  @positions.each do |p|
	    if p.type.class.to_s == "Water" && p.group == group
	      sum += p.water_content
		  count += 1
	    end
	  end
	  if count > 1
	    left_over = sum % count
	    amount_for_each = sum / count
	    # distribute the water to postions
	    @positions.each do |p|
	      if p.type.class.to_s == "Water" && p.group == group
	        p.water_content = amount_for_each		
	      end
	    end
	
	    # need to assign the left over to the first position in the the group
	    @positions.each_with_index do |p,index|
	      if p.type.class.to_s == "Water" && p.group == group
	        p.water_content += left_over if left_over > 0
		    break
          end
        end
	    #@positions[0].water_content += left_over if left_over > 0
	  end
	end
	
	if @log == true
	  @logger.write "water equalized"
	end
  end
  
  #still under construction
  def earth_water_spread
	# @positions.each_with_index do |p,index|
	  # if (p.type.class.to_s == "Earth") && (p.water_content % 5 == 0)
	    # p.temperature -= 1
		# @positions[0].water_content += 1
		# p.water_content -= 1
	  # end
	# end
	
	
	@positions.each_with_index do |p,index|
	  if p.type.class.to_s == "Earth" && p.water_content > 8
	    n = check_neighbours(index)
		#puts "---- earth water spread"
		# puts n
        # puts "----"
		sum = p.water_content
        #left_over = sum % 8
	    amount_for_each = sum / 8
		#puts left_over
		#puts amount_for_each
		
		n.each do |np|
		  np.water_content += amount_for_each
		  p.water_content -= amount_for_each
		end
		# puts "----"
		# puts left_over
		# puts p.water_content
		# puts "----"
	  end
	end
	
	if @log == true
	  @logger.write "earth water spread"
	end
  end
  
  def check_neighbours(loc)
    #@positions[loc-1].neighbours = []
	p = []
	p << assign_cell(-1, -1, loc) #top left
    p << assign_cell(0, -1, loc) #top
    p << assign_cell(1, -1, loc) #top right
    p << assign_cell(-1, 0, loc) #left
    p << assign_cell(1, 0, loc) #right
    p << assign_cell(-1, 1, loc) #bottom left
    p << assign_cell(0, 1, loc) #bottom
    p << assign_cell(1, 1, loc) #bottom right
	
	p
  end
  
  def get_neighbours(loc,step)
    #@positions[loc-1].neighbours = []
	p = []
	p << assign_cell(-1*step, -1*step, loc) #top left
    p << assign_cell(0*step, -1*step, loc) #top
    p << assign_cell(1*step, -1*step, loc) #top right
    p << assign_cell(-1*step, 0*step, loc) #left
    p << assign_cell(1*step, 0*step, loc) #right
    p << assign_cell(-1*step, 1*step, loc) #bottom left
    p << assign_cell(0*step, 1*step, loc) #bottom
    p << assign_cell(1*step, 1*step, loc) #bottom right
	
	p
  end
  
  def find_cell(x,y)
    cell = Position.new
    @positions.each_with_index do |i,index|
      if i.x == x && i.y == y
        cell = i
		#puts index
        break
      end
    end
    cell
  end

  def assign_cell(x,y,loc)

	x1 = @positions[loc].x + x
	x = x1
    if x < 1
	  x = (@width) + x 
    elsif x == 0
	  x = @positions[loc].x 
	elsif x > @width
	  x = x - @width 
	end
	
	y1 = @positions[loc].y + y
	y = y1
    if y < 1
	  y = (@height) + y 
    elsif y == 0
      y = @positions[loc].y 
    elsif y > @height
	  y = y - @height 
	end
		
    find_cell(x,y) 
  end

  # def within_bounds?(x,y)
    # if (x > 0 && y > 0) && (x <= @width && y <= @height)
      # true
    # else
      # false
    # end 
  # end
  
  
  
  # this is one world move, an hour human time approximation
  def tick
  
	move_sun
	weather
	earth_water_spread
	wind
	equalize_water
	paint_world
	#paint_world4 paints to file
	
	# this is every second, for testing
    #sleep @interval if @interval != 0
	
	@day += 1 if @sun_location == @width
	
	if @log == true
	  @logger.write "tick"
	end
  end
  
end


