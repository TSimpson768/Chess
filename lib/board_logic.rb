module BoardLogic
  def initialize_copy(original_board)
    @board = original_board.clone_board
  end

  def clone_board
    @board.map { |row| row.map(&:clone) }
  end

  # Returns two arrays of possible moves.An entry in the first is the starting pos
  # For that move, the entry in the seccond array with the same index is the destination
  # Player, Bool -> [[], []]
  def list_moves(player, for_player)
    (0..self.class::ROWS - 1).each_with_object([[], []]) do |x, attacks|
      (0..self.class::COLUMNS - 1).each_with_object(attacks) do |y, attacked_spaces|
        piece = locate_piece([y, x])
        push_piece_moves([y, x], attacked_spaces) if piece && helper_for_list_moves(player, piece.owner, for_player)

        attacked_spaces
      end
    end
  end

  def push_piece_moves(coords, attacked_spaces)
    piece = locate_piece(coords)
    attacked_by_piece = piece.possible_moves(coords, self).compact
    attacked_by_piece.length.times { attacked_spaces[0].push(coords) }
    attacked_by_piece.each { |attacked_pos| attacked_spaces[1].push(attacked_pos) }
  end

  # Player, player, bool
  # If equal == true, return result of player == piece_owner
  # else, return player =! piece_owner
  def helper_for_list_moves(player, piece_owner, equal)
    if equal
      player == piece_owner
    else
      player != piece_owner
    end
  end

  # Lists all spaces that are under attack.
  def list_unsafe_spaces(player)
    list_moves(player, false)[1]
  end

  # [int, int] - > place
  # Returns the place at coords
  def locate_place(coords)
    return nil if out_of_bounds?(coords)

    @board[coords[0]][coords[1]]
  end
end
