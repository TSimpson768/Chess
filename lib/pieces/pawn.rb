require 'pry'
require_relative 'piece'
require_relative '../moveList'
class Pawn < Piece
  def initialize(owner)
    super(owner)
    @moves = set_moves
    @start_rank = set_start_rank
    @move_direction = set_move_direction
  end

  def possible_moves(pos, board)
    moves = []
    next_space = [pos[0] + @move_direction, pos[1]]
    moves.push(next_space) unless board.locate_piece(next_space)
    double = double_move(pos, board)
    captures = captures(pos, board)
    moves.push(double) unless double.nil?
    captures.each { |cap_move| moves.push(cap_move) } unless captures.empty?
    ep_moves = en_passant_moves(pos, board)
    moves.push(ep_moves) unless ep_moves.nil?
    moves
  end

  private

  def set_symbol
    return '♙' if @owner.colour == WHITE
    return '♟︎' if @owner.colour == BLACK
  end

  def set_moves
    return [MoveList.new([1, 0])] if @owner.colour == WHITE
    return [MoveList.new([-1, 0])] if @owner.colour == BLACK
  end

  def double_move(pos, board)
    return if pos[0] != @start_rank

    in_between = [pos[0] + @move_direction, pos[1]]
    destination = [pos[0] + @move_direction * 2, pos[1]]
    return destination unless board.locate_piece(in_between) || board.locate_piece(destination)

    nil
  end

  def captures(pos, board)
    possible_moves = []
    capture_moves = [[@move_direction, 1], [@move_direction, -1]]
    capture_moves.each do |move|
      next_move = [pos[0] + move[0], pos[1] + move[1]]
      next if out_of_bounds?(next_move)

      next_piece = board.locate_piece(next_move)
      next unless next_piece

      possible_moves.push(next_move) if next_piece.owner != @owner
    end
    possible_moves
  end

  def en_passant_moves(pos, board)
    en_passant_targets = [[pos[0], pos[1] - 1], [pos[0], pos[1] + 1]]
    en_passant_targets.each do |target|
      next if out_of_bounds?(target)

      target_piece = board.locate_piece(target)
      return [target[0] + @move_direction, target[1]] if !target_piece.nil? && target_piece == board.last_moved_piece
    end
    nil
  end

  def set_start_rank
    return 1 if owner.colour == WHITE
    return 6 if owner.colour == BLACK
  end

  def set_move_direction
    return 1 if owner.colour == WHITE
    return -1 if owner.colour == BLACK
  end

  # HACK: Function copy - pasted from moveList class. Needs to be in module?
  def out_of_bounds?(next_pos)
    next_pos.any? { |coord| coord < 0 || coord > 7 }
  end
end
