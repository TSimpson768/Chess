module BoardBuilder
  private

  # Player, Player -> 8 * 8 Array of pieces
  def initialize_board(white, black)
    board = []
    8.times do
      row = []
      8.times do
        row.push(Place.new)
      end
      board.push(row)
    end
    board[0][0].enter_place(Rook.new(white))
    board[0][1].enter_place(Knight.new(white))
    board[0][2].enter_place(Bishop.new(white))
    board[0][3].enter_place(Queen.new(white))
    board[0][4].enter_place(King.new(white))
    board[0][5].enter_place(Bishop.new(white))
    board[0][6].enter_place(Knight.new(white))
    board[0][7].enter_place(Rook.new(white))
    board[1].each do |place|
      piece = Pawn.new(white)
      place.enter_place(piece)
    end

    board[6].each do |place|
      piece = Pawn.new(black)
      place.enter_place(piece)
    end
    board[7][0].enter_place(Rook.new(black))
    board[7][1].enter_place(Knight.new(black))
    board[7][2].enter_place(Bishop.new(black))
    board[7][3].enter_place(Queen.new(black))
    board[7][4].enter_place(King.new(black))
    board[7][5].enter_place(Bishop.new(black))
    board[7][6].enter_place(Knight.new(black))
    board[7][7].enter_place(Rook.new(black))
    board
  end
end
