# The board class stores the current state of the board.
require_relative 'place'
require_relative 'constants'
# Might need a module to take the print_methods
class Board
  include Constants
  ROWS = 8
  COLUMNS = 8
  def initialize
    # An array of 64 piece objects. Needs to be created in the starting possition for chess.
    @board = initialize_board
  end

  # Return true if in check
  def check?
    
  end

  # Return true if in checkmate
  def checkmate?
    
  end

  # Return true if a stalemate occurs
  def stalemate?
    
  end

  # [[int,int],[int,int]]-> boolean
  # Retrun true if the move from start_place to end place is legal. Else, return false
  # Plan 1 - is start place owned by the current player? return false if false
  # 2 - Starting from the start_place, perform a search (Depth or breath first? idk)
  # return true if an unobstructed path to end place is found. 
  def legal?(move)
    start = move[0]
    destination = move[1]
    piece = locate_piece(start)
    possible_moves = piece.possible_moves
    possible_moves.each do |possible_move|
      after_move = [start[0] + possible_move[0], start[1] + possible_move[1]]
      return true if after_move == destination
    end
    
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

  # [Int, int] -> Piece or nil gets a pointer to the piece at the given co-ordinates, if it exists
  def locate_piece(coords)
    place = @board[coords[0]][coords[1]]
    place.piece
  end
end