# The board class stores the current state of the board.
require_relative 'place'
require_relative 'constants'
require 'pry'
# Might need a module to take the print_methods
class Board
  include Constants
  ROWS = 8
  COLUMNS = 8
  def initialize
    # An array of 64 piece objects. Needs to be created in the starting possition for chess.
    @board = initialize_board
    @last_moved_piece = nil
  end

  attr_reader :last_moved_piece

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
  # To get around messy output of list_moves
  def checkmate?(player)
    return false unless check?(player)

    # Get all legal moves for player
    starts, destinations = list_moves(player, true)
    destinations.each_with_index do |move, index|
      return false unless check_after_move?(starts[index], move, player)
    end
    true
  end

  # Return true if player is in stalemate (no legal moves)
  def stalemate?(player)
    return false if check?(player)

    moves = list_moves(player, true)[1]
    moves.empty?
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
    return false if !piece || piece.owner != player

    possible_moves = piece.possible_moves(start, self)
    possible_moves.any? { |reachable_coord| reachable_coord == destination }
  end

  # Return true if moving from start to end will leave player in check
  # TODO
  def check_after_move?(start_pos, end_pos, player)
  end

  # Move the piece on start_place to end place
  def move_piece(move)
    
  end

  # Print the board to the console
  def print_board
    print_divider
    @board.each do |row|
      print_row(row)
      print_divider
    end
  end

  # [Int, int] -> Piece or nil gets a pointer to the piece at the given co-ordinates, if it exists
  def locate_piece(coords)
    place = @board[coords[0]][coords[1]]
    place.piece
  end

  # Return true if a piece belonging to owner can leagally occupy pos. Else, return false
  # TODO: Return false for Out of bounds position
  def valid_pos?(pos, owner)
    piece = locate_piece(pos)

    return true if piece.nil? || piece.owner != owner

    false
  end

  private

  def initialize_board
    board = []
    ROWS.times do
      row = []
      COLUMNS.times do
        row.push(Place.new)
      end
      board.push(row)
    end
    board
  end

  def print_row(row)
    print '|'
    row.each {|place| place.print_place}
    puts ' '
  end

  def print_divider
    puts '================================='
  end

  # Returns two arrays of possible moves.An entry in the first is the starting pos
  # For that move, the entry in the seccond array with the same index is the destinatino
  # HACK :, and mabye shorten function
  def list_moves(player, for_player)
    (0..ROWS - 1).each_with_object([[], []]) do |x, attacked_spaces|
      (0..COLUMNS - 1).each_with_object(attacked_spaces) do |y, attacked_spaces|
        piece = locate_piece([y, x])
        if piece && helper_for_list_moves(player, piece.owner, for_player)
          attacked_by_piece = piece.possible_moves([y, x], self)
          attacked_by_piece.length.times { attacked_spaces[0].push([y, x]) }
          attacked_by_piece.each { |attacked_pos| attacked_spaces[1].push(attacked_pos)}
        end
        attacked_spaces
      end
    end
  end

  def list_unsafe_spaces(player)
    list_moves(player, false)[1]
  end

  # Player, player, bool
  # If equal == true, return result of player == piece_owner
  # else, return player =! piece_owner
  def helper_for_list_moves(player, piece_owner, equal)
    if equal
      player == piece_owner
    else
      player != piece_owner
    end
  end
end

