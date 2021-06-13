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
  def make_move
    
  end
  
  # Code to run when the game ends
  def game_over 
    
  end

  private

  # Takes a player input if it is valid (correctly formatted? Legal might be in make move)
  def input_move
    
  end
end

Game.new.play
