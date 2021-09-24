# frozen_string_literal: true

# The board class stores the current state of the board.
require_relative 'place'
require_relative 'constants'
require_relative 'pieces/piece'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'strategy/move'
require_relative 'strategy/promote'
require_relative 'strategy/enpassant'
require_relative 'strategy/castle'
require_relative 'board_output'
require_relative 'board_logic'
require_relative 'board_builder'

require 'pry'
# Might need a module to take the print_methods
class Board
  include Constants
  include BoardOutput
  include BoardLogic
  include BoardBuilder
  ROWS = 8
  COLUMNS = 8
  def initialize(white, black, board = initialize_board(white, black), en_passant_target = nil, fifty_move_count = 0)
    # An array of 64 piece objects. Needs to be created in the starting possition for chess.
    @board = board
    # [array, array] Location of a piece that can be captured via en-passant
    @en_passant_target = en_passant_target
    @fifty_move_count = fifty_move_count
  end

  attr_reader :en_passant_target

  # Return true if in check
  def check?(player)
    attacked_spaces = list_unsafe_spaces(player).compact
    attacked_spaces.each do |space|
      piece = locate_piece(space)
      return true if piece && piece.owner == player && piece.instance_of?(King)
    end
    false
  end

  # Return true if player is in checkmate
  def checkmate?(player)
    return false unless check?(player)

    starts, destinations = list_moves(player, true)
    destinations.each_with_index do |move, index|
      next unless valid_move(starts[index], move, player)

      return false unless check_after_move?([starts[index], move], player)
    end
    puts 'Checkmate!'
    true
  end

  # Return true if player is in stalemate (no legal moves)
  def stalemate?(player)
    return false if check?(player)

    moves = list_moves(player, true)[1]
    return unless moves.empty?

    puts 'Stalemate - Its a draw!'
    true
  end

  # [[int,int],[int,int]]-> boolean
  # Retrun true if the move from start_place to end place is legal. Else, return false
  # Plan 1 - is start place owned by the current player? return false if false
  # 2 - Starting from the start_place, perform a search (Depth or breath first? idk)
  # return true if an unobstructed path to end place is found.
  def legal?(move, player)
    start = move[0]
    destination = move[1]
    piece = locate_piece(start)
    return false unless valid_move(start, destination, player)

    possible_moves = piece.possible_moves(start, self)
    possible_moves.any? { |reachable_coord| reachable_coord == destination }
  end

  # Returns true if a piece can move from start to destination without causing check or moving an opponents piece
  def valid_move(start, destination, player)
    return false unless valid_pos?(destination, player) && locate_piece(start)&.owner == player
    return false if check_after_move?([start, destination], player)
    return false unless safe_path_for_king?(start, destination, player)

    true
  end

  def safe_path_for_king?(start, destination, player)
    piece = locate_piece(start)
    return false if piece.instance_of?(King) && (start[1] - destination[1]).abs == 2 && check_after_move?(
      [start, [start[0], (start[1] + destination[1]) / 2]], player
    )

    true
  end

  # Return true if moving from start to end will leave player in check
  # This needs move piece to not check legality
  def check_after_move?(move, player)
    board_clone = clone
    p move
    strategy = get_strategy(move)
    strategy = Move.new if strategy.instance_of?(Promote)

    board_clone.move_piece(move, strategy)
    board_clone.check?(player)
  end

  # Move the piece on start_place to end place
  def move_piece(move, strategy = get_strategy(move))
    @board = strategy.make_move(move, @board)
    @en_passant_target = ep_target(move)
  end

  # [Int, int] -> Piece or nil gets a pointer to the piece at the given co-ordinates, if it exists
  def locate_piece(coords)
    place = locate_place(coords)
    place&.piece
  end

  # Return true if a piece belonging to owner can leagally occupy pos. Else, return false
  def valid_pos?(pos, owner)
    piece = locate_piece(pos)

    return true if piece.nil? || piece.owner != owner

    false
  end

  private

  # I don't like a 4 pronged conditional here. Is there a better way to do this?
  def get_strategy(move)
    if (move[0][1] - move[1][1]).abs == 2 && locate_piece(move[0]).instance_of?(King)
      Castle.new
    elsif (move[0][0] - move[1][0]).abs == 1 && (move[0][1] - move[1][1]).abs == 1 &&
          locate_piece(move[0]).instance_of?(Pawn) && locate_piece(move[1]).nil?
      EnPassant.new
    elsif (move[1][0] == 0 || move[1][0] == 7) && locate_piece(move[0]).instance_of?(Pawn)
      Promote.new
    else
      Move.new
    end
  end

  def ep_target(move)
    possible_target = locate_piece(move[1])
    return nil unless possible_target.instance_of?(Pawn) && (move[0][0] - move[1][0]).abs == 2

    move[1]
  end

  def out_of_bounds?(next_pos)
    next_pos.any? { |coord| coord.negative? || coord > 7 }
  end
end
