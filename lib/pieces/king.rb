# The class for a king piece
require_relative 'piece'
require_relative '../moveList'
require_relative '../constants'

class King < Piece
  def initialize(owner)
    super(owner)
    @moves = create_moves
  end

  private

  def set_symbol
    return '♔' if @owner.colour == WHITE
    return '♚' if @owner.colour == BLACK
  end

  def create_moves
    [MoveList.new([1, 0]), MoveList.new([-1, 0]), MoveList.new([0, 1]),
     MoveList.new([0, -1]), MoveList.new([1, 1]), MoveList.new([-1, 1]),
     MoveList.new([1, -1]), MoveList.new([-1, -1])]
  end
end
