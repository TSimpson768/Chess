# frozen_string_literal: true

require 'yaml'

# A module containing the logic relating to saving and loading games. Stolen and
# modified from the hangman project (this is why you keep your code modular).
# TODO: Convert to using YAML as it is easier to use.
module Saves
  SAVE_FOLDER = "#{Dir.pwd}/saves/"

  private

  # Read a save file, and attempt to initialize a game from it
  def load_game
    print_saves
    begin
      read_save
    rescue IOError, SystemCallError
      puts 'File not found'
      load_game
    end
  end

  def read_save
    file_name = input_save_name
    save = File.open(file_name, 'r')
    save_json = YAML.load(save.read)
    save.close
    save_json
  end

  def input_save_name
    print 'Enter save name:'
    SAVE_FOLDER + "#{gets.chomp}.YAML"
  end

  # Saves are serialized in JSON format. This would have been much easier in YAML(Yaml.dump(self))
  def save_game
    file_name = input_save_name
    begin
      Dir.mkdir('saves') unless Dir.exist?('saves')
      save_file = File.new(file_name, 'w')
      save_file.puts generate_save
      save_file.close
      puts 'Game saved!'
    rescue IOError
      puts 'Save failed'
    end
  end

  # TODO: Generate yaml of game
  def generate_save
    YAML.dump(self)
  end
end
