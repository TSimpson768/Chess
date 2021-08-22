# frozen_string_literal: true

require_relative 'saves'
require_relative 'game'
require_relative 'player'
class Menu
  include Saves

  def main_menu
    puts 'Welcome to Chess!'
    instructions
    puts 'Would you like to'
    puts '1. Start a new game, or'
    puts '2. Load a saved game'
    input = input_option

    case input
    when 1
      Game.new.play
    when 2
      read_save.play
    end
  end

  def input_option
    loop do
      input = gets.chomp.to_i
      return input if [1, 2].include?(input)

      puts 'Error!'
    end
  end

  def instructions
    puts 'This is a command line chess game which implements all the rules of chess except'
    puts 'draws by threefold repetition and the 50 move rule. This game currently supports'
    puts 'play between two human players.'
    puts
    puts 'To make a move, type in the coordinates of the piece'
    puts 'you want to move, followed by the destination coordinates, ie A2A4 to move the piece'
    puts 'on A2 to A4. To castle, move the king to its destination after castling.'
    puts
    puts 'When check occurs, the player will be notified. Only moves out of check are accepted'
    puts 'The game will end upon checkmate or stalemate'
    puts
    puts 'To save, type s or S when making a move.'
  end
end
