# frozen_string_literal: true

# The class for a king piece
require_relative 'piece'
require_relative '../moveList'
require_relative '../constants'

# TODO: - Implement castling move checks
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
    return "\e[37m♚\e[39m" if @owner.colour == WHITE
    return "\e[30m♚\e[39m" if @owner.colour == BLACK
  end

  def create_moves
    [MoveList.new([1, 0]), MoveList.new([-1, 0]), MoveList.new([0, 1]),
     MoveList.new([0, -1]), MoveList.new([1, 1]), MoveList.new([-1, 1]),
     MoveList.new([1, -1]), MoveList.new([-1, -1])]
  end

  # HACK: This can be tided up to only need 1 helper i think
  # Could this cause infinte check checks again, in a case where both players can castle?
  # Castling moves returns possible castlling moves the king can make
  # Calling check? is causing that little fuck up again
  def castling_moves(pos, board)
    return [] if @owner.check || pos[1] != 4 || !@owner.can_castle

    home_rank = (0..7).map { |index| board.locate_piece([pos[0], index]) }
    [castle_queenside(home_rank[0..3], pos, board), castle_kingside(home_rank[5..7], pos, board)].compact
  end

  def castle_queenside(qside_pieces, pos, _board)
    rook = qside_pieces[0]
    return unless rook && rook.owner == @owner && !rook.moved

    # unsafe = board.list_unsafe_spaces(@owner)
    [pos[0], 2] # unless unsafe.member?([pos[0], 3])
  end

  def castle_kingside(kside_pieces, pos, _board)
    rook = kside_pieces[2]
    return unless rook && rook.owner == @owner && !rook.moved

    # unsafe = board.list_unsafe_spaces(@owner)
    [pos[0], 6] # unless unsafe.member?([pos[0], 5])
  end
end
