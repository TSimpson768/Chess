# The class for a king piece
require_relative 'piece'
require_relative '../moveList'
require_relative '../constants'

# TODO - Implement castling move checks
class King < Piece
  def initialize(owner)
    super(owner)
    @moves = create_moves
  end

  def possible_moves(pos, board)
    normal_moves = super(pos, board)
    return normal_moves if @moved

    normal_moves.push(castling_moves(pos, board))
  end

  private

  def set_symbol
    return '♔' if @owner.colour == WHITE
    return '♚' if @owner.colour == BLACK
  end

  def create_moves
    [MoveList.new([1, 0]), MoveList.new([-1, 0]), MoveList.new([0, 1]),
     MoveList.new([0, -1]), MoveList.new([1, 1]), MoveList.new([-1, 1]),
     MoveList.new([1, -1]), MoveList.new([-1, -1])]
  end

  def castling_moves(pos, board)
    return if board.check?(@owner) && pos[1] != 4
    
  end
end
