require_relative 'piece'
require_relative '../moveList'

# A chess bishop
class Bishop < Piece
  def initialize(owner)
    super(owner)
    @moves = [MoveList.new([1, 1], true), MoveList.new([1, -1], true), MoveList.new([-1, 1], true),
              MoveList.new([-1, -1], true)]
  end

  private

  def set_symbol
    return '♗' if @owner.colour == WHITE
    return '♝' if @owner.colour == BLACK
  end
end
