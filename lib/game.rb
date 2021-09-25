# frozen_string_literal: true

# The game class is in charge of controlling the flow of the game
class Game
  require_relative 'board'
  require_relative 'player'
  require_relative 'constants'
  require_relative 'saves'
  require_relative 'position'
  include Saves
  include Constants
  def initialize(white = Player.new(WHITE), black = Player.new(BLACK), board = Board.new(white, black))
    @board = board
    @current_player = white
    @opposing_player = black
    @fifty_move_count = 0
    @previous_positions = [Position.new(@board.clone, @current_player.clone, @opposing_player.clone)]
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
  # board.legal? - returns true if the move is legal
  def make_move
    move = nil
    loop do
      move = input_move
      break if @board.legal?(move, @current_player)

      puts 'Please enter a legal move'
    end
    update_fifty_move_counter(move)
    @board.move_piece(move)
    @previous_positions.push(Position.new(@board.clone, @opposing_player.clone, @current_player.clone))
  end

  def update_fifty_move_counter(move)
    @fifty_move_count += 1
    @fifty_move_count = 0 if @board.locate_piece(move[0]).instance_of?(Pawn) || @board.locate_piece(move[1])
  end

  # Code to run when the game ends
  def game_over?
    checkmate = @board.checkmate?(@opposing_player)
    return unless checkmate || @board.stalemate?(@opposing_player) || @fifty_move_count >= 100 || threefold_repeat?

    puts 'Game over!'
    puts "#{@current_player.colour} won!" if checkmate
    true
  end

  def threefold_repeat?
    @previous_positions.count(@previous_positions.last) >= 3
  end

  # Solicits player input. For a move, returns player input in the form [[y, x], [y, x]]
  # Valid inputs - match move regex, with start and destination squares.
  # 0-0-0 or 0-0 - castling moves.
  # S or SAVE - save game.
  # h or HELP - print a help screen
  # q or quit - quit game.

  def input_move
    input = gets.chomp.downcase
    case input
    when /[a-h][1-8][a-h][1-8]/
      process_input(input)
    when '0-0-0'
      castle(false)
    when '0-0'
      castle(true)
    when /s/, /save/
      save_game
    when 'h', 'help'
      print_in_game_help
    when 'q', 'quit'
      quit_game
    else
      puts "I don't understand that. Please input a move in format [starting square][destination]
 I.e. to move the piece at A1 to D4, type A1D4"
      input_move
    end
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

  def castle(kingside)
    rank = @current_player.colour == WHITE ? 0 : 7
    dest_file = kingside ? 6 : 2
    [[rank, 4], [rank, dest_file]]
  end
end
