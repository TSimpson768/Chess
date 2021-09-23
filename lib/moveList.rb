# frozen_string_literal: true

require 'pry'
# Movelist starts with a posible move, and wether or not that move is
# sliding (like a rook, bishop or queen)
# TODO: Refactor
class MoveList
  def initialize(move, sliding = false)
    @move = move
    @sliding = sliding
  end

  # [int, int], board, player -> array of [int, int]
  # Returns all the valid moves from this sliding move, starting at
  # starting_position
  def valid_moves(starting_position, board, owner)
    next_pos = [starting_position[0] + @move[0], starting_position[1] + @move[1]]
    return non_slide_move(next_pos, board, owner) unless @sliding

    generate_slide_moves(next_pos, board, owner)
  end

  private

  def out_of_bounds?(next_pos)
    next_pos.any? { |coord| coord.negative? || coord > 7 }
  end

  # Rewrite this as a recursive function. If current pos is legal to move to, add it.
  # [int, int], board, owner -> nil or [[int, int], [int, int], ... , nil ]
  def generate_slide_moves(current_pos, board, owner)
    return if out_of_bounds?(current_pos)

    next_piece = board.locate_piece(current_pos)
    return if next_piece&.owner == owner

    return [current_pos] if next_piece

    next_pos = [current_pos[0] + @move[0], current_pos[1] + @move[1]]
    next_moves = generate_slide_moves(next_pos, board, owner)
    return [current_pos] unless next_moves

    next_moves.reduce([current_pos]) { |current_moves, deep_moves| current_moves.push(deep_moves) }
  end

  def non_slide_move(pos, board, owner)
    return [] if out_of_bounds?(pos)

    board.valid_pos?(pos, owner) ? [pos] : []
  end
end
