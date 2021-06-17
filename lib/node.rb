# Node represents an individual possible move for a piece,
# relative to the initial position of the piece.
# For sliding pieces, next move represents the next possible move
# in that direction. The plan is to use this to perform a Depth first
# search for a destination in a pieces legal moveset, or just to 
# return every possible move when looking for mates
class Node
  def initialize(move = [0, 0], next_node = nil)
    @move = move
    @next_node = next_node
  end
end
