# frozen_string_literal: true

require_relative 'constants'
# Represents one of the players
class Player
  include Constants
  def initialize(colour = WHITE, can_castle = true)
    @colour = colour
    @can_castle = can_castle
    @check = false
  end
  attr_reader :colour
  attr_accessor :check, :can_castle

  def ==(other)
    @colour == other.colour && @check == other.check && @can_castle == other.can_castle
  end
end
