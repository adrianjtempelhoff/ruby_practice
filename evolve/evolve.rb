require_relative "world"

puts "--- E-volve ---"

world = World.new
world.create_world

#world.paint_world
#n = world.check_neighbours(479)
#puts "!!!!!!!!!!!!!!!!!!!!! #{n.inspect}"
#puts "!!!!!!!!!!!!!!!!!!!!! #{n[0].x}, #{n[0].y}; #{n[1].x}, #{n[1].y}; #{n[2].x}, #{n[2].y}; #{n[3].x}, #{n[3].y}; #{n[4].x}, #{n[4].y}; #{n[5].x}, #{n[5].y}; #{n[6].x}, #{n[6].y}; #{n[7].x}, #{n[7].y};"
#puts "!!!!!!!!!!!!!!!!!!!!! #{n[0].type.class.to_s}, #{n[1].type.class.to_s}, #{n[2].type.class.to_s}, #{n[3].type.class.to_s}, #{n[4].type.class.to_s}, #{n[5].type.class.to_s}, #{n[6].type.class.to_s}, #{n[7].type.class.to_s}"
#sleep 1
#n.each_with_index do |p,index|
#  p.symbol = "#{index}"
#end
#world.paint_world


#world.create_position("water")
#world.create_position("earth")
#world.show

##with speed, please
#world.interval = 0

## weather
world.show_weather = true

##dont log it
world.log = false
##show me the world
#world.paint_world
tw = world.total_water

#sleep 1
1000.times do |i|
  #world.show
  world.tick
end
if world.log == true
  world.logger.close
end
world.show
world.paint_world2
f=world.paint_world3
#puts f
puts "#{((f[0].to_f / (world.height*world.width).to_f)*100).to_s} % inhabitable"
puts "#{((f[1].to_f / (world.height*world.width).to_f)*100).to_s} % uninhabitable"
#puts "----"
#puts world.positions.map {|x| x.group if x.type.class.to_s == "Water" }.uniq
#puts "----"
puts tw
puts world.total_water
puts "rain : #{world.rain_count}"
puts "snow : #{world.snow_count}"

# symbols explanation:
#   # is for earth
#   = is for mud
#   ~ is for water
#   . is for nothing
#   % is for ice
#   s is for snow
#   r is for rain
#   h is for inhabitable position
#   x is for uninhabitable position



