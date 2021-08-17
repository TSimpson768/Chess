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

    castle_moves = castling_moves(pos, board)
    castle_moves.each { |move| normal_moves.push(move) }

    normal_moves.compact
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

  # HACK: Kinda spaghetti
  # Castling moves returns possible castlling moves the king can make
  def castling_moves(pos, board)
    return if board.check?(@owner) && pos[1] != 4

    home_rank = (0..7).map { |index| board.locate_piece([pos[0], index]) }
    [castle_queenside(home_rank[0..3], pos, board), castle_kingside(home_rank[5..7], pos, board)].compact
  end

  def castle_queenside(qside_pieces, pos, board)
    rook = qside_pieces[0]
    return unless rook && rook.owner == @owner && !rook.moved

    return [pos[0], 2] unless board.check_after_move?([pos, [pos[0], 3]], owner) && board.check_after_move?([pos, [pos[0], 2]], owner)
  end


  def castle_kingside(kside_pieces, pos, board)
    
  end
end
