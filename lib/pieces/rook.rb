# frozen_string_literal: true

require_relative 'piece'
require_relative '../moveList'

class Rook < Piece
  def initialize(owner, moved = false)
    super(owner, moved)
    @moves = [MoveList.new([1, 0], true), MoveList.new([-1, 0], true), MoveList.new([0, 1], true),
              MoveList.new([0, -1], true)]
  end

  private

  def set_symbol
    return '♖' if @owner.colour == WHITE
    return '♜' if @owner.colour == BLACK
  end
end
