# Base strategy for moving pieces in a chessboard
class Move
  def make_move(move, board)
    piece = locate_place(move[0], board).exit_place
    locate_place(move[1], board).enter_place(piece)
    board
  end

  private

  # Return the place object at pos in board array
  def locate_place(pos, board)
    board[pos[0]][pos[1]]
  end
end
