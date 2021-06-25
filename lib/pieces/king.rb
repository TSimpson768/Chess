# The class for a king piece
require_relative 'piece'
require_relative '../moveList'
class King < Piece
  MOVES = [MoveList.new([1, 0]), MoveList.new([-1, 0]), MoveList.new([0, 1]),
           MoveList.new([0, -1]), MoveList.new([1, 1]), MoveList.new([-1, 1]),
           MoveList.new([1, -1]), MoveList.new([-1, -1])].freeze
  # Return an array containing every space on the board this piece can legally move to
  # [int, int], board -> Array of [int, int]
  def possible_moves(pos, board)
    MOVES.reduce([]) { |all_moves, move| all_moves.push(move.valid_moves(pos, board, owner)) }
  end

  private

  def set_symbol
    '♔' if @owner.colour == WHITE
    '♚' if @owner.colour == BLACK
  end
end
