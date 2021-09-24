# Movement strategy for castling
require_relative 'move'
class Castle < Move
  def make_move(move, board)
    moved_king_board = super(move, board)
    locate_place(move[1], board).piece.owner.can_castle = false
    super(rook_move(move[1]), moved_king_board)
  end

  private

  def rook_move(king_destination)
    rank = king_destination[0]
    king_destination[1] < 4 ? [[rank, 0], [rank, 3]] : [[rank, 7], [rank, 5]]
  end
end
