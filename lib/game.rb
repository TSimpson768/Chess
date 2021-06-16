# The game class is in charge of controlling the flow of the game
class Game
  require_relative 'board'
  require_relative 'player'
  def initialize(board = Board.new, white = Player.new, black = Player.new)
    @board = board
    @current_player = white
    @opposing_player = black
  end
  # Main game loop
  def play
    @board.print_board
  end
  # Switch current and opposing players
  def switch_players
    
  end

  # Make a valid move
  # loop do
  # input move - returns move if it is correctly formatted
  # board.legal? - returns true if the move is lega;
  def make_move
    loop do
      move = input_move
      break if @board.legal?(move)
    end
    @board.move(move)
  end
  
  # Code to run when the game ends
  def game_over 
    
  end
  
  # Takes a player input if it is valid (correctly formatted? Legal might be in make move)
  def input_move
    move_regex = /[a-h][1-8][a-h][1-8]/
    input = gets.chomp.downcase
    if move_regex.match?(input)
      process_input(input)
    end
  end

  private

  def process_input(input)
    input_array = input.split(//)
    processed_input = input_array.map { |char| process_char(char) }
    destination = processed_input.pop(2)
    [processed_input, destination]
  end

  def process_char(char)
    processed_char = char.ord
    processed_char < 96 ? processed_char - 49 : processed_char - 97
  end
end



#Game.new.play
