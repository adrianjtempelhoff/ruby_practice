require_relative '../cell'
require_relative '../game'

describe Cell, "and its states" do
  it "should not be nil" do
    cell = Cell.new
    cell.should_not eq(nil)
  end
  it "should have a state of alive" do
    cell = Cell.new
    cell.live!
    cell.state.should eq('alive')
  end
  it "should have a state of dead" do
    cell = Cell.new
    cell.die!
    cell.state.should eq('dead')
  end
end


describe Game, "basic example" do
  it "should not be nil" do
    game = Game.new
    game.should_not eq(nil)
  end
  it "should have world cells" do
    game = Game.new
    game.init
    game.world_cells.should_not eq(nil)
  end
end