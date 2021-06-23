# Movelist starts with a posible move, and wether or not that move is
# sliding (like a rook, bishop or queen)
class MoveList
  def initialize(move, sliding = false)
    @move = move
    @sliding = sliding
  end

  # [int, int], board, player -> array of [int, int]
  # Returns all the valid moves from this sliding move, starting at
  # starting_position
  def valid_moves(starting_position, board, owner)
    moves = []
    return moves if sliding == false

    loop do
      next_pos = [starting_position[0] + move[0], starting_position[1] + move[1]]
      next_piece = board.locate_piece(next_pos)
      if next_piece
        moves.push(next_pos) if owner != next_piece.owner
        break
      end
      moves.push(next_pos)
      starting_position = next_pos
    end
  end
end
