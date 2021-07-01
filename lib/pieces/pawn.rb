class Pawn < Piece
  def initialize(owner)
    super(owner)
    @moves = set_moves
  end

  def possible_moves(pos, board)
    moves = super(pos, board)
    moves.push(double_move(pos, board))

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
    return [] if pos[0] != 1

    in_between = [pos[0] + 1, pos[1]]
    destination = [pos[0] + 2, pos[1]]
    return destination unless board.locate_piece(in_between) && board.locate_piece(destination)

    []
  end
end
