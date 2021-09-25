# frozen_string_literal: true

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
    return "\e[37m♞\e[39m" if @owner.colour == WHITE
    return "\e[30m♞\e[39m" if @owner.colour == BLACK
  end
end
