# An instance of place represents an individual place on the chessboard.
# At a minimum, needs to contain a piece and @attacked, to check if the square is attacked
# for check and mates May also add links to neighbors
class Place
  def initialize(piece = nil)
    @piece = piece
  end
  attr_reader :piece

  def print_place
    if @piece
      print " #{@piece.symbol} "
    else
      print '   '
    end
    print '|'
  end

  def ==(other)
    @piece == other.piece
  end
  def exit_place
    piece = @piece
    @piece = nil
    piece
  end

  def enter_place(piece)
    @piece = piece
  end
end
