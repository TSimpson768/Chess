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

require 'pry'
# Might need a module to take the print_methods
class Board
  include Constants
  ROWS = 8
  COLUMNS = 8
  def initialize(white, black, board = initialize_board(white, black), en_passant_target = nil)
    # An array of 64 piece objects. Needs to be created in the starting possition for chess.
    @board = board
    # [array, array] Location of a piece that can be captured via en-passant
    @en_passant_target = en_passant_target
  end

  def initialize_copy(original_board)
    @board = original_board.clone_board
  end

  def clone_board
    @board.map { |row| row.map(&:clone) }
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
  # To get around messy output of list_moves
  def checkmate?(player)
    return false unless check?(player)

    # Get all legal moves for player
    starts, destinations = list_moves(player, true)
    destinations.each_with_index do |move, index|
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
    return false if !piece || piece.owner != player
    return false if check_after_move?([start, destination], player)
    return false if piece.instance_of?(King) && (start[1] - destination[1]).abs == 2 && check_after_move?(
      [start, [start[0], (start[1] + destination[1]) / 2]], player
    )

    possible_moves = piece.possible_moves(start, self)
    possible_moves.any? { |reachable_coord| reachable_coord == destination }
  end

  # Return true if moving from start to end will leave player in check
  # This needs move piece to not check legality
  def check_after_move?(move, player)
    board_clone = clone
    board_clone.move_piece(move)
    board_clone.check?(player)
  end

  # Move the piece on start_place to end place
  def move_piece(move)
    strategy = get_strategy(move)
    @board = strategy.make_move(move, @board)
    @en_passant_target = ep_target(move)
  end

  # Print the board to the console
  def print_board
    print_header
    print_divider
    @board.reverse.each_with_index do |row, index|
      print "#{ROWS - index} "
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

  # Lists all spaces that are under attack.
  def list_unsafe_spaces(player)
    list_moves(player, false)[1]
  end

  # [int, int] - > place
  # Returns the place at coords
  def locate_place(coords)
    @board[coords[0]][coords[1]]
  end

  private

  # Player, Player -> 8 * 8 Array of pieces
  def initialize_board(white, black)
    board = []
    ROWS.times do
      row = []
      COLUMNS.times do
        row.push(Place.new)
      end
      board.push(row)
    end
    board[0][0].enter_place(Rook.new(white))
    board[0][1].enter_place(Knight.new(white))
    board[0][2].enter_place(Bishop.new(white))
    board[0][3].enter_place(Queen.new(white))
    board[0][4].enter_place(King.new(white))
    board[0][5].enter_place(Bishop.new(white))
    board[0][6].enter_place(Knight.new(white))
    board[0][7].enter_place(Rook.new(white))
    board[1].each do |place|
      piece = Pawn.new(white)
      place.enter_place(piece)
    end

    board[6].each do |place|
      piece = Pawn.new(black)
      place.enter_place(piece)
    end
    board[7][0].enter_place(Rook.new(black))
    board[7][1].enter_place(Knight.new(black))
    board[7][2].enter_place(Bishop.new(black))
    board[7][3].enter_place(Queen.new(black))
    board[7][4].enter_place(King.new(black))
    board[7][5].enter_place(Bishop.new(black))
    board[7][6].enter_place(Knight.new(black))
    board[7][7].enter_place(Rook.new(black))
    board
  end

  def print_row(row)
    print '|'
    row.each(&:print_place)
    puts ' '
  end

  def print_header
    puts '    A   B   C   D   E   F   G   H   '
  end

  def print_divider
    puts '==================================='
  end

  # Returns two arrays of possible moves.An entry in the first is the starting pos
  # For that move, the entry in the seccond array with the same index is the destination
  def list_moves(player, for_player)
    (0..ROWS - 1).each_with_object([[], []]) do |x, attacked_spaces|
      (0..COLUMNS - 1).each_with_object(attacked_spaces) do |y, attacked_spaces|
        piece = locate_piece([y, x])
        if piece && helper_for_list_moves(player, piece.owner, for_player)
          attacked_by_piece = piece.possible_moves([y, x], self)
          attacked_by_piece.length.times { attacked_spaces[0].push([y, x]) }
          attacked_by_piece.each { |attacked_pos| attacked_spaces[1].push(attacked_pos) }
        end
        attacked_spaces
      end
    end
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

  # [int, int], piece, place
  # Return unless pawn is moving.
  # If pawn is moving into an empty square, remove ep target
  # Else if pawn is moving 2 spaces, set as ep target
  # def process_en_passant(move, piece, destination)
  #   return unless piece.instance_of?(Pawn)

  #   if @en_passant_target && move[0][1] != move[1][1] && destination.piece.nil?
  #     locate_place(@en_passant_target).exit_place
  #     @en_passant_target = nil
  #   elsif (move[0][0] - move[1][0]).abs == 2
  #     @en_passant_target == move[1]
  #   end
  # end

  # def process_castling(move, piece)
  #   return unless piece.instance_of?(King) && (move[0][1] - move[1][1]).abs == 2

  #   case move[1][1]
  #   when 2
  #     rook = locate_place([move[0][0], 0]).exit_place
  #     locate_place([move[0][0], 3]).enter_place(rook)
  #   when 6
  #     rook = locate_place([move[0][0], 7]).exit_place
  #     locate_place([move[0][0], 5]).enter_place(rook)
  #   end
  #end
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
    return nil unless locate_piece(move[1]).instance_of?(Pawn) && (move[0][0] - move[1][0]).abs == 2

    move[1]
  end
end
