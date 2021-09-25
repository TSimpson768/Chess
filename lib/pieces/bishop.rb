# frozen_string_literal: true

require_relative 'piece'
require_relative '../moveList'

# A chess bishop
class Bishop < Piece
  def initialize(owner, moved = false)
    super(owner, moved)
    @moves = [MoveList.new([1, 1], true), MoveList.new([1, -1], true), MoveList.new([-1, 1], true),
              MoveList.new([-1, -1], true)]
  end

  private

  def set_symbol
    return "\e[37m♝\e[39m" if @owner.colour == WHITE
    return "\e[30m♝\e[37m" if @owner.colour == BLACK
  end
end
