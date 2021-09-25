# frozen_string_literal: true

# Represents a chess queen
require_relative 'piece'
require_relative '../moveList'
class Queen < Piece
  def initialize(owner, moved = false)
    super(owner, moved)
    @moves = [MoveList.new([1, 0], true), MoveList.new([-1, 0], true), MoveList.new([0, 1], true),
              MoveList.new([0, -1], true), MoveList.new([1, 1], true), MoveList.new([-1, 1], true),
              MoveList.new([1, -1], true), MoveList.new([-1, -1], true)]
  end

  private

  def set_symbol
    return "\e[37m♛\e[39m" if @owner.colour == WHITE
    return "\e[30m♛\e[39m" if @owner.colour == BLACK
  end
end
