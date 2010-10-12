require 'test/unit'
require './board.rb'  
  
class BoardTests < Test::Unit::TestCase
  EMPTY_BOARD = 
    "  ABCDEFGH\n" +
    "1 --------\n" +
    "2 --------\n" +
    "3 --------\n" +
    "4 ---WB---\n" +
    "5 ---BW---\n" +
    "6 --------\n" +
    "7 --------\n" +
    "8 --------"
               
  def test_new_baord_is_initialised_correctly
    b = Board.new
    assert_equal(EMPTY_BOARD, b.to_s)
  end

  def test_new_board_coin_4D_is_white
    b = Board.new
    assert_equal(b.get_coin('4D').colour, 'W')
  end

  def test_new_board_coin_4E_is_black
    b = Board.new
    assert_equal(b.get_coin('4E').colour, 'B')
  end

  def test_coin_1A_neighbouring_coins
    b = Board.new
    coin_1A = b.get_coin('1A')
    assert_equal(coin_1A.coin_to_the_north.to_s, '')
    assert_equal(coin_1A.coin_to_the_north_east.to_s, '')
    assert_equal(coin_1A.coin_to_the_east.to_s, '1B')
    assert_equal(coin_1A.coin_to_the_south_east.to_s, '2B')
    assert_equal(coin_1A.coin_to_the_south.to_s, '2A')
    assert_equal(coin_1A.coin_to_the_south_west.to_s, '')
    assert_equal(coin_1A.coin_to_the_west.to_s, '')
    assert_equal(coin_1A.coin_to_the_north_west.to_s, '')
  end

  def test_coin_1H_neighbouring_coins
    b = Board.new
    coin_1H = b.get_coin('1H')
    assert_equal(coin_1H.coin_to_the_north.to_s, '')
    assert_equal(coin_1H.coin_to_the_north_east.to_s, '')
    assert_equal(coin_1H.coin_to_the_east.to_s, '')
    assert_equal(coin_1H.coin_to_the_south_east.to_s, '')
    assert_equal(coin_1H.coin_to_the_south.to_s, '2H')
    assert_equal(coin_1H.coin_to_the_south_west.to_s, '2G')
    assert_equal(coin_1H.coin_to_the_west.to_s, '1G')
    assert_equal(coin_1H.coin_to_the_north_west.to_s, '')
  end

  def test_coin_8A_neighbouring_coins
    b = Board.new
    coin_8A = b.get_coin('8A')
    assert_equal(coin_8A.coin_to_the_north.to_s, '7A')
    assert_equal(coin_8A.coin_to_the_north_east.to_s, '7B')
    assert_equal(coin_8A.coin_to_the_east.to_s, '8B')
    assert_equal(coin_8A.coin_to_the_south_east.to_s, '')
    assert_equal(coin_8A.coin_to_the_south.to_s, '')
    assert_equal(coin_8A.coin_to_the_south_west.to_s, '')
    assert_equal(coin_8A.coin_to_the_west.to_s, '')
    assert_equal(coin_8A.coin_to_the_north_west.to_s, '')
  end

  def test_coin_8H_neighbouring_coins
    b = Board.new
    coin_8H = b.get_coin('8H')
    assert_equal(coin_8H.coin_to_the_north.to_s, '7H')
    assert_equal(coin_8H.coin_to_the_north_east.to_s, '')
    assert_equal(coin_8H.coin_to_the_east.to_s, '')
    assert_equal(coin_8H.coin_to_the_south_east.to_s, '')
    assert_equal(coin_8H.coin_to_the_south.to_s, '')
    assert_equal(coin_8H.coin_to_the_south_west.to_s, '')
    assert_equal(coin_8H.coin_to_the_west.to_s, '8G')
    assert_equal(coin_8H.coin_to_the_north_west.to_s, '7G')
  end

  def test_coin_4C_neighbouring_coins
    b = Board.new
    coin_4C = b.get_coin('4C')
    assert_equal(coin_4C.coin_to_the_north.to_s, '3C')
    assert_equal(coin_4C.coin_to_the_north_east.to_s, '3D')
    assert_equal(coin_4C.coin_to_the_east.to_s, '4D')
    assert_equal(coin_4C.coin_to_the_south_east.to_s, '5D')
    assert_equal(coin_4C.coin_to_the_south.to_s, '5C')
    assert_equal(coin_4C.coin_to_the_south_west.to_s, '5B')
    assert_equal(coin_4C.coin_to_the_west.to_s, '4B')
    assert_equal(coin_4C.coin_to_the_north_west.to_s, '3B')
  end

  def test_coin_may_not_be_placed_on_another_coin
    b = Board.new
    assert_equal(b.is_valid_move('4D', 'W'), false)
  end
  
  def test_coin_may_not_be_placed_unless_at_least_1_adjacent_coin_is_opposite_colour
    b = Board.new
    assert_equal(b.is_valid_move('3C', 'W'), false)
  end

  def test_valid_moves_for_black_correct
    b = Board.new
    b.determine_valid_moves('B')
    assert_equal(b.to_s, 
      "  ABCDEFGH\n" +
      "1 --------\n" +
      "2 --------\n" +
      "3 ---O----\n" +
      "4 --OWB---\n" +
      "5 ---BWO--\n" +
      "6 ----O---\n" +
      "7 --------\n" +
      "8 --------"
    )
  end

  def test_get_valid_moves_for_black_correct
    b = Board.new
    assert_equal(b.get_valid_moves('B'), ['3D', '4C', '5F', '6E'])
  end

  def test_valid_moves_for_white_correct
    b = Board.new
    b.determine_valid_moves('W')
    assert_equal(b.to_s, 
      "  ABCDEFGH\n" +
      "1 --------\n" +
      "2 --------\n" +
      "3 ----O---\n" +
      "4 ---WBO--\n" +
      "5 --OBW---\n" +
      "6 ---O----\n" +
      "7 --------\n" +
      "8 --------"
    )
  end
  
  def test_invalid_move_for_black_raises
    begin
      b = Board.new
      b.move('D6', 'B')
    rescue Exception => e
    end
    assert_equal(ArgumentError, e.class)
  end

  def test_valid_move_for_black_correct
    b = Board.new
    b.move('4C', 'B')
    assert_equal(b.to_s,
      "  ABCDEFGH\n" +
      "1 --------\n" +
      "2 --------\n" +
      "3 --------\n" +
      "4 --BBB---\n" +
      "5 ---BW---\n" +
      "6 --------\n" +
      "7 --------\n" +
      "8 --------"
    )
  end

  def test_valid_move_for_white_correct
    b = Board.new
    b.move('4C', 'B')
    b.move('3C', 'W')
    assert_equal(b.to_s,
      "  ABCDEFGH\n" +
      "1 --------\n" +
      "2 --------\n" +
      "3 --W-----\n" +
      "4 --BWB---\n" +
      "5 ---BW---\n" +
      "6 --------\n" +
      "7 --------\n" +
      "8 --------"
    )
  end

  def test_new_baord_white_score_correct
    b = Board.new
    assert_equal(b.get_score('W'), 2)
  end
end
