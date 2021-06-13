# The board class stores the current state of the board.
require_relative 'place'
class Board
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

  # str, str -> boolean
  # Retrun true if the move from start_place to end place is legal. Else, return false
  # Plan 1 - is start place owned by the current player? return false if false
  # 2 - Starting from the start_place, perform a search (Depth or breath first? idk)
  # return true if an unobstructed path to end place is found. 
  def legal?(start_place, end_place)
    
  end

  # Move the piece on start_place to end place
  def move(start_place, end_place)
    
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
end