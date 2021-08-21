require_relative 'saves'
require_relative 'game'
require_relative 'player'
class Menu
  include Saves

  def main_menu
    puts 'Welcome to Chess!'
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
      return input if input == 1 || input == 2

      puts 'Error!'
    end
  end
end