class Coin
  attr :row, false
  attr :column, false
  attr :colour, true
  attr :coin_to_the_north, true
  attr :coin_to_the_north_east, true
  attr :coin_to_the_east, true
  attr :coin_to_the_south_east, true
  attr :coin_to_the_south, true
  attr :coin_to_the_south_west, true
  attr :coin_to_the_west, true
  attr :coin_to_the_north_west, true
  
  def initialize(row, column, colour)
    @row = row
    @column = column
    @colour = colour
  end
  
  def to_s
    row + column
  end
end