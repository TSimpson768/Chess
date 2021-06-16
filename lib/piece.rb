require_relative 'constants'
# Represents an individual piece. May need a load of children to
# represent each piece. Also needs a pointer to its owner
class Piece
  include Constants
  def initialize(owner)
    @owner = owner
    @symbol = set_symbol
  end
  attr_reader :symbol, :owner

  def set_symbol
    'W' if @owner.colour == WHITE

    'B' if @owner.colour == BLACK
  end
end
