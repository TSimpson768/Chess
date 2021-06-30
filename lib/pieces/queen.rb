# Represents a chess queen
require_relative 'piece'
require_relative '../moveList'
class Queen < Piece
  def initialize(owner)
    super(owner)
    @moves = [MoveList.new([1, 0] ,true), MoveList.new([-1, 0] ,true), MoveList.new([0, 1] ,true),
              MoveList.new([0, -1] ,true), MoveList.new([1, 1] ,true), MoveList.new([-1, 1] ,true),
              MoveList.new([1, -1] ,true), MoveList.new([-1, -1] ,true)]
  end

  private

  def set_symbol
    '♕' if @owner.colour == WHITE

    '♛' if @owner.colour == BLACK
  end
end
