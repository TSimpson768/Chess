# Represents a chess queen
require_relative 'piece'
require_relative '../moveList'
class Queen < Piece
  MOVES = [MoveList.new([1, 0] ,true), MoveList.new([-1, 0] ,true), MoveList.new([0, 1] ,true),
  MoveList.new([0, -1] ,true), MoveList.new([1, 1] ,true), MoveList.new([-1, 1] ,true),
  MoveList.new([1, -1] ,true), MoveList.new([-1, -1] ,true)].freeze

  # TODO: Not DRY. Need a way to have a moves class be set for individual decendents with this method
  def possible_moves(pos, board)
    legal_moves = MOVES.reduce([]) { |all_moves, move| all_moves.push(move.valid_moves(pos, board, owner)) }
    legal_moves.flatten(1)
  end

  def set_symbol
    '♕' if @owner.colour == WHITE

    '♛' if @owner.colour == BLACK
  end
end
