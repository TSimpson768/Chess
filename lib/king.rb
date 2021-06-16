# The class for a king piece
require_relative 'piece'
class King < Piece
  
  # Return an array of every possible move this piece can make relative
  # to it's current possition
  def possible_moves
    
  end

  private

  def set_symbol
    '♔' if @owner.colour == WHITE
    '♚' if @owner.colour == BLACK
  end
end
