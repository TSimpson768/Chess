require_relative 'constants'
# Represents one of the players
class Player
  include Constants
  def initialize(colour = WHITE)
    @colour = colour
  end
  attr_reader :colour
  attr_accessor :check
end
