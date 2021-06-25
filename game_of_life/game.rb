require_relative 'cell'
class Game
  attr_accessor :world_cells, :height, :width, :ticks
  #@world_cells = []
  #@height = 25
  #@width = 55

  def initialize
    @world_cells = []
    @height = 25
    @width = 55
    @ticks = 60
  end

  def init
    count = 0
    @height.times do |j|
      @width.times do |i|
        cell = Cell.new
        cell.y = j + 1
        cell.x = i + 1
        cell.die!#
        @world_cells[count] = cell
        count += 1
      end
    end
    init_setup(count-1)
    paint
  end

  def init_setup limit
    amount = limit/2
    amount.times do |i|
      num = Random.rand(limit)
      @world_cells[num].live!
    end
  end

  def paint
    count = 0
    @height.times do
      @width.times do
        print @world_cells[count].symbol
        @world_cells[count].neighbours = []
        count += 1
      end
      puts ''
    end
    puts '------------'
  end

  def tick
    #sleep 1
    count = 1
    temp_wc = []
    @world_cells.each do |i|
      check_neighbours count
      n_count = count_live_neighbours(i)
      #puts count_live_neighbours(i)
    
      #Any live cell with fewer than two live neighbours dies, as if caused by under-population.
      if n_count < 2
        temp_wc << {:index => count-1, :state => 'dead'} if i.state=='alive'
      end

      #Any live cell with two or three live neighbours lives on to the next generation.
      if n_count == 2 || n_count == 3
        temp_wc << {:index => count-1, :state => 'alive'} if i.state=='alive'
      end

      #Any live cell with more than three live neighbours dies, as if by overcrowding.
      if n_count > 3
        temp_wc << {:index => count-1, :state => 'dead'} if i.state=='alive'
      end

      #Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
      if n_count == 3
        temp_wc << {:index => count-1, :state => 'alive'} if i.state=='dead'
      end

      count += 1
    end

    temp_wc.each do |i|
      @world_cells[i[:index]].die! if i[:state] == 'dead'
      @world_cells[i[:index]].live! if i[:state] == 'alive'
    end

    paint
  end

  def count_live_neighbours cell
    count = 0
    cell.neighbours.each do |i|
      count += 1 if i.state == 'alive'
    end
    count
  end



  def check_neighbours loc
    #assign_cell(-1,-1,loc) #top left
    #assign_cell(0,-1,loc) #top
    #assign_cell(1,-1,loc) #top right
    #assign_cell(-1,0,loc) #left
    #assign_cell(1,0,loc) #right
    #assign_cell(-1,1,loc) #bottom left
    #assign_cell(0,1,loc) #bottom
    #assign_cell(1,1,loc) #bottom right

    x,y = -1,-1
    3.times do |i|
      3.times do |j|
        assign_cell(x,y,loc) if (x != 0 || y != 0)
        x += 1
      end
      x = -1
      y += 1
    end
  end

  def find_cell(x,y)
    cell = Cell.new
    @world_cells.each do |i|
      if i.x == x && i.y == y
        cell = i
        break
      end
    end
    cell
  end

  def assign_cell(x,y,loc)
    x = @world_cells[loc-1].x + x
    y = @world_cells[loc-1].y + y
    @world_cells[loc-1].neighbours << find_cell(x,y) if within_bounds?(x,y)
  end

  def within_bounds?(x,y)
    if (x > 0 && y > 0) && (x < @width+1 && y < @height+1)
      true
    else
      false
    end 
  end

  def start
    init
    #puts @ticks
    @ticks.times do
      tick
    end
  end
end