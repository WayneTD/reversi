require './coin.rb'

class Board
  EMPTY_BOARD = 
    '--------' +
    '--------' +
    '--------' +
    '---WB---' +
    '---BW---' +
    '--------' +
    '--------' +
    '--------'

  def initialize
    @coins = []
    coinIdx = 0
    ('1'..'8').each do |row|
      ('A'..'H').each do |column|
        @coins << Coin.new(row, column, EMPTY_BOARD[coinIdx, 1])
        coinIdx += 1
      end
    end
    assign_adjacent_coins
  end
    
  def to_s
    coinIdx = 0
    result = "  ABCDEFGH\n"
    8.times do |rowIdx|
      result << (rowIdx + 1).to_s + ' '
      8.times do
        result << @coins[coinIdx].colour
        coinIdx += 1
      end
      result << "\n"
    end
    result.chomp
  end
  
  def get_coin(row_column)
    @coins.find { |coin| coin.row == row_column[0,1] and coin.column == row_column[1,1] }
  end
  
  def is_valid_move(row_column, colour)
    coin = get_coin(row_column)
    return false if coin == nil

    return false if coin.colour != '-'

    adjacentCoinsWithOppositeColour = get_adjacent_coins_with_opposite_colour(coin, colour)
    return false if adjacentCoinsWithOppositeColour.length == 0

    adjacentCoinsWithOppositeColour.each do |adjacentCoinWithOppositeColour|     
      coinsInSameRowColumnOrDiagonalAsAdjacentCoin = get_coins_in_same_row_column_or_diagonal_as_adjacent_coin(coin, adjacentCoinWithOppositeColour)
      return true if coinsInSameRowColumnOrDiagonalAsAdjacentCoin.find { |c| c.colour == colour } != nil
    end
    
    false
  end
  
  def determine_valid_moves(colour)
    @coins.each do |coin|
      coin.colour = 'O' if is_valid_move(coin.to_s, colour)
    end
  end
  
  def get_valid_moves(colour)
    valid_moves = []
    @coins.each do |coin|
      valid_moves << coin.to_s if is_valid_move(coin.to_s, colour)
    end
    valid_moves
  end

  def move(row_column, colour)
    raise ArgumentError.new("Invalid move: #{row_column}, '#{colour}'") unless is_valid_move(row_column, colour)
    coin = get_coin(row_column)
    
    adjacentCoinsWithOppositeColour = get_adjacent_coins_with_opposite_colour(coin, colour)
    adjacentCoinsWithOppositeColour.each do |adjacentCoinWithOppositeColour|     
      coinsInSameRowColumnOrDiagonalAsAdjacentCoin = get_coins_in_same_row_column_or_diagonal_as_adjacent_coin(coin, adjacentCoinWithOppositeColour)
      if coinsInSameRowColumnOrDiagonalAsAdjacentCoin.find { |c| c.colour == colour } != nil
        coinsInSameRowColumnOrDiagonalAsAdjacentCoin.each { |c| c.colour = colour if c.colour != '-' }
        adjacentCoinWithOppositeColour.colour = colour
      end
    end

    coin.colour = colour
  end
  
  def get_score(colour)
    @coins.count { |coin| coin.colour == colour }
  end
  
  private
    def assign_adjacent_coins
      rows = %w'1 2 3 4 5 6 7 8'
      columns = %w'A B C D E F G H'
    
      @coins.each do |coin|
        row_idx = rows.find_index(coin.row)
        row_to_the_north = row_idx == 0 ? ' ' : rows[row_idx - 1]
        row_to_the_south = row_idx == 7 ? ' ' : rows[row_idx + 1]
        column_idx = columns.find_index(coin.column)
        column_to_the_west = column_idx == 0 ? ' ' : columns[column_idx - 1]    
        column_to_the_east = column_idx == 7 ? ' ' : columns[column_idx + 1]
        coin.coin_to_the_north = get_coin(row_to_the_north + coin.column)
        coin.coin_to_the_north_east = get_coin(row_to_the_north + column_to_the_east)    
        coin.coin_to_the_east = get_coin(coin.row + column_to_the_east)    
        coin.coin_to_the_south_east = get_coin(row_to_the_south + column_to_the_east)    
        coin.coin_to_the_south = get_coin(row_to_the_south + coin.column)    
        coin.coin_to_the_south_west = get_coin(row_to_the_south + column_to_the_west)    
        coin.coin_to_the_west = get_coin(coin.row + column_to_the_west)    
        coin.coin_to_the_north_west = get_coin(row_to_the_north + column_to_the_west)    
      end
    end
    
    def get_adjacent_coins(coin)
      adjacent_coins = []
      adjacent_coins << coin.coin_to_the_north
      adjacent_coins << coin.coin_to_the_north_east
      adjacent_coins << coin.coin_to_the_east
      adjacent_coins << coin.coin_to_the_south_east
      adjacent_coins << coin.coin_to_the_south
      adjacent_coins << coin.coin_to_the_south_west
      adjacent_coins << coin.coin_to_the_west
      adjacent_coins << coin.coin_to_the_north_west
      adjacent_coins
    end
    
    def get_adjacent_coins_with_opposite_colour(coin, colour)
      oppositeColour = get_opposite_colour(colour)
      adjacentCoinsWithOppositeColour = []
      get_adjacent_coins(coin).each do |coin|
        adjacentCoinsWithOppositeColour << coin if coin != nil and coin.colour == oppositeColour
      end
      adjacentCoinsWithOppositeColour
    end
    
    def get_opposite_colour(colour)
      if colour == 'B'then 'W' else 'B'end
    end
    
    def get_coins_in_same_row_column_or_diagonal_as_adjacent_coin(coin, adjacentCoin)
      if coin.row == adjacentCoin.row
        coinsInRow = []
        @coins.each do |coinInRow|
          coinsInRow << coinInRow if coinInRow != coin and coinInRow != adjacentCoin and coinInRow.row == coin.row
        end
        coinsInRow
      elsif coin.column == adjacentCoin.column
        coinsInColumn = []
        @coins.each do |coinInColumn|
          coinsInColumn << coinInColumn if coinInColumn != coin and coinInColumn != adjacentCoin and coinInColumn.column == coin.column
        end
        coinsInColumn
      else
        coinsInDiagonal = []
        if coin.coin_to_the_north_west == adjacentCoin or coin.coin_to_the_south_east == adjacentCoin
          coinToTheNorthWest = coin.coin_to_the_north_west
          until coinToTheNorthWest == nil
            coinsInDiagonal <<  coinToTheNorthWest if coinToTheNorthWest != coin and coinToTheNorthWest != adjacentCoin
            coinToTheNorthWest = coinToTheNorthWest.coin_to_the_north_west
          end
          coinToTheSouthEast = coin.coin_to_the_south_east
          until coinToTheSouthEast == nil
            coinsInDiagonal <<  coinToTheSouthEast if coinToTheSouthEast != coin and coinToTheSouthEast != adjacentCoin
            coinToTheSouthEast = coinToTheSouthEast.coin_to_the_south_east
          end
        elsif coin.coin_to_the_north_east == adjacentCoin or coin.coin_to_the_south_west == adjacentCoin
          coinToTheNorthEast = coin.coin_to_the_north_east
          until coinToTheNorthEast == nil
            coinsInDiagonal <<  coinToTheNorthEast if coinToTheNorthEast != coin and coinToTheNorthEast != adjacentCoin
            coinToTheNorthEast = coinToTheNorthEast.coin_to_the_north_east
          end
          coinToTheSouthWest = coin.coin_to_the_south_west
          until coinToTheSouthWest == nil
            coinsInDiagonal <<  coinToTheSouthWest if coinToTheSouthWest != coin and coinToTheSouthWest != adjacentCoin
            coinToTheSouthWest = coinToTheSouthWest.coin_to_the_south_west
          end
        end
        coinsInDiagonal
      end
    end
end