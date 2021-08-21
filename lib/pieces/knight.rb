require_relative 'piece'
require_relative '../moveList'

# A chess knight
class Knight < Piece
  def initialize(owner, moved = false)
    super(owner, moved)
    @moves = [MoveList.new([2, 1]), MoveList.new([2, -1]), MoveList.new([1, 2]),
              MoveList.new([-1, 2]), MoveList.new([1, -2]), MoveList.new([-1, -2]),
              MoveList.new([-2, 1]), MoveList.new([-2, -1])]
  end

  private

  def set_symbol
    return '♘' if @owner.colour == WHITE
    return '♞' if @owner.colour == BLACK
  end
end