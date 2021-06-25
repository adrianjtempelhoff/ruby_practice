require_relative 'cell'
require_relative 'game'

if ARGV[0] == '-h' || ARGV[0] == '--help' || ARGV[0].nil?
  puts <<-EOF
  **GAME OF LIFE**

  Usage:
    game_of_life width,height ticks

  Example:
    game_of_life 20,20 60
  EOF
else
  width,height,ticks = 0,0,0
  width,height = ARGV[0].split(',') if !ARGV[0].nil?
  ticks = ARGV[1].to_i if !ARGV[1].nil?

  my_game = Game.new
  my_game.width = width.to_i if width != 0
  my_game.height = height.to_i if height != 0
  my_game.ticks = ticks if ticks > 0
  my_game.start
  #my_game.init
  puts my_game.check_neighbours 2
  end






