# frozen_string_literal: true

# The game class is in charge of controlling the flow of the game
class Game
  require_relative 'board'
  require_relative 'player'
  require_relative 'constants'
  require_relative 'saves'
  include Saves
  include Constants
  def initialize(white = Player.new(WHITE), black = Player.new(BLACK), board = Board.new(white, black))
    @board = board
    @current_player = white
    @opposing_player = black
    @fifty_move_count = 0
    @previous_positions = []
  end

  # Main game loop

  def play
    loop do
      @board.print_board
      puts "#{@current_player.colour} to move"
      make_move
      break if game_over?

      manage_check
      switch_players
    end
  end

  def manage_check
    @current_player.check = false
    if @board.check?(@opposing_player)
      puts 'Check!'
      @opposing_player.check = true
    end
  end

  # Switch current and opposing players
  def switch_players
    temp = @current_player
    @current_player = @opposing_player
    @opposing_player = temp
  end

  # Make a valid move
  # loop do
  # input move - returns move if it is correctly formatted
  # board.legal? - returns true if the move is lega;
  def make_move
    move = nil
    loop do
      move = input_move
      break if @board.legal?(move, @current_player)

      puts 'Please enter a legal move'
    end
    update_fifty_move_counter(move)
    @board.move_piece(move)
  end

  def update_fifty_move_counter(move)
    @fifty_move_count += 1
    @fifty_move_count = 0 if @board.locate_piece(move[0]).instance_of?(Pawn) || @board.locate_piece(move[1])
  end

  # Code to run when the game ends
  def game_over?
    checkmate = @board.checkmate?(@opposing_player)
    return unless checkmate || @board.stalemate?(@opposing_player)

    puts 'Game over!'
    puts "#{@current_player.colour} won!" if checkmate
    true
  end

  # Takes a player input if it is valid (correctly formatted? Legal might be in make move)
  def input_move
    move_regex = /[a-h][1-8][a-h][1-8]/
    input = nil
    loop do
      input = gets.chomp.downcase
      break if move_regex.match?(input)

      if /[Ss]/.match?(input)
        save_game
        next
      end
      puts "I don't understand that. Please input a move in format [starting square][destination]
 I.e. to move the piece at A1 to D4, type A1D4"
    end
    process_input(input)
  end

  private

  def process_input(input)
    input_array = input.split(//)
    processed_input = input_array.map { |char| process_char(char) }
    destination = processed_input.pop(2)
    [processed_input.reverse, destination.reverse]
  end

  def process_char(char)
    processed_char = char.ord
    processed_char < 96 ? processed_char - 49 : processed_char - 97
  end
end
