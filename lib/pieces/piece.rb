require_relative '../constants'
# Represents an individual piece. May need a load of children to
# represent each piece. Also needs a pointer to its owner
class Piece
  include Constants
  def initialize(owner)
    @owner = owner
    @symbol = set_symbol
  end
  attr_reader :symbol, :owner

  # Return an array containing every space on the board this piece can legally move to
  # [int, int], board -> Array of [int, int]
  def possible_moves(pos, board)
    moves = @moves.reduce([]) { |all_moves, move| all_moves.push(move.valid_moves(pos, board, @owner)) }
    moves.flatten(1)
  end

  def set_symbol
    return 'W' if @owner.colour == WHITE
    return 'B' if @owner.colour == BLACK
  end
end
