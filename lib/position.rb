class Position
  def initialize(board, current_player, opposing_player)
    @board = board
    @current_player = current_player
    @opposing_player = opposing_player
  end
  attr_reader :board, :current_player, :opposing_player

  def ==(other)
    @board == other.board && @current_player == other.current_player && @opposing_player == other.opposing_player
  end
end
