class Promote < Move
  def make_move(move, board)
    old_piece = locate_place(move[0], board).exit_place
    new_piece = solicit_promotion(old_piece)
    locate_place(move[1], board).enter_place(new_piece)
    board
  end

  def solicit_promotion(old_piece)
    owner = old_piece.owner
    case input_promotion
    when 'Q'
      Queen.new(owner, true)
    when 'R'
      Rook.new(owner, true)
    when 'B'
      Bishop.new(owner, true)
    when 'K'
      Knight.new(owner, true)
    end
  end

  private

  def input_promotion
    puts 'Your pawn made it to the other end of the board!'
    puts 'Would you like to promote it to a [Q]ueen, [R]ook, [B]ishop or [K]night?'
    loop do
      input = gets.chomp.upcase
      return input if /[QRBK]/.match?(input)

      puts "I don't understand that. Type the first letter of the piece you want to promote to"
    end
  end
end