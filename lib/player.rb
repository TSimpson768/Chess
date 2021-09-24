# frozen_string_literal: true

require_relative 'constants'
# Represents one of the players
class Player
  include Constants
  def initialize(colour = WHITE, can_castle = true)
    @colour = colour
    @can_castle = can_castle
  end
  attr_reader :colour
  attr_accessor :check, :can_castle
end
