require_relative 'move'
class EnPassant < Move
  
  def make_move(move, board)
    super(move, board)
    # The piece to be removed has y from initial part of move, and x from final
    enpassant_location = find_ep_target(move)
    locate_place(enpassant_location, board).exit_place
    board
  end

  private

  def find_ep_target(move)
    [move[0][0], move[1][1]]
  end
end
