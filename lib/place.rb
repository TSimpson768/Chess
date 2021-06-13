# An instance of place represents an individual place on the chessboard.
# At a minimum, needs to contain a piece and @attacked, to check if the square is attacked
# for check and mates May also add links to neighbors
class Place
  def initialize(piece = nil)
    @piece = piece
  end

  def print_place
    if @piece
      print " #{@piece.symbol} "
    else
      print '   '
    end
    print '|'
  end
end
