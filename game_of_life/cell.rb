class Cell
  attr_accessor :state, :symbol, :neighbours, :x, :y

  def initialize
    @state = 'NA'
    @symbol = ' '
    @neighbours = []
  end
  def live!
    @state = 'alive'
    @symbol = 'o'
  end
  def die!
    @state = 'dead'
    @symbol = '.'
  end
end