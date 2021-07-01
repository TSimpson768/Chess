class Pawn < Piece
  def initialize(owner)
    super(owner)
    @moves = set_moves
  end

  def possible_moves(pos, board)
    moves = super(pos, board)
    double = double_move(pos, board)
    captures = captures(pos, board)
    moves.push(double) unless double.nil?
    moves.push(captures) unless captures.empty?

    moves
  end
  private

  def set_symbol
    '♙' if @owner.colour == WHITE
    '♟︎' if @owner.colour == BLACK
  end

  def set_moves
    [MoveList.new([1, 0])]
  end

  def double_move(pos, board)
    return if pos[0] != 1

    in_between = [pos[0] + 1, pos[1]]
    destination = [pos[0] + 2, pos[1]]
    return destination unless board.locate_piece(in_between) && board.locate_piece(destination)

    []
  end
  # Hack? - I don't lke having to flatten at end
  def captures(pos, board)
    possible_moves = []
    capture_moves = [[1, 1], [1, -1]]
    capture_moves.each do |move|
      next_move = [pos[0] + move[0], pos[1] + move[1]]
      next_piece = board.locate_piece(next_move)
      next unless next_piece

      possible_moves.push(next_move) if next_piece.owner != @owner
    end
    possible_moves.flatten(1)
  end
end
