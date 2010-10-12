require './board.rb'  

board = Board.new
currentColour = 'B'
message = ''
currentMove = ''
lastBlackMove = ''
lastWhiteMove = ''

until currentMove == "Q"
  currentColourDescription = currentColour == 'B' ? 'Black' : 'White'
  nextColour = currentColour == 'B' ? 'W' : 'B'
  blackScore = board.get_score('B')
  whiteScore = board.get_score('W')

  puts `clear`
  puts 'Ruby Reversi by Wayne Davies'
  puts '----------------------------'
  puts
  puts board.to_s
  puts
  puts "Scores:  Black(B): #{blackScore}  White(W): #{whiteScore}"
  puts
  puts 'You are playing Black.'

  puts message if message.length > 0
  message = ''

  valid_moves = board.get_valid_moves(currentColour)
  if valid_moves.length == 0
    if board.get_valid_moves(nextColour).length == 0
      puts
      if blackScore > whiteScore
        puts "Game over! **** You WON #{blackScore} - #{whiteScore}! :-) ****"
      elsif blackScore == whiteScore
        puts "Game over! **** You DREW #{blackScore} each! :-| ****"
      else
        puts "Game over! **** You LOST #{blackScore} - #{whiteScore}! :-( ****"
      end
      puts
      currentMove = 'Q'
      next
    else
      message << "#{currentColourDescription} could not move!"
      currentColour = nextColour
      next
    end
  end

  puts "Valid moves are #{valid_moves.to_s.gsub(/[\[\]\"]/, '')}."
  puts 'Enter M if you want the computer to move for you.'
  puts 'Enter Q to quit.'
  puts 'Enter a valid move...'
    
  currentMove = gets.chomp.upcase if currentColour == 'B'
  currentMove = valid_moves[rand(valid_moves.length)] if currentColour == 'W' or currentMove == 'M'
  
  next if currentMove == 'Q'
  
  if board.is_valid_move(currentMove, currentColour)
    board.move currentMove, currentColour
    if currentColour == 'B' then lastBlackMove = currentMove else lastWhiteMove = currentMove end
    message << "Black move was #{lastBlackMove}."
    message << " White move was #{lastWhiteMove}." if lastWhiteMove.length > 0
    currentColour = nextColour
  else
    message << "Invalid move! Try again..."
  end
end
