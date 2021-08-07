require '../lib/board'
require '../lib/place'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/queen'
require '../lib/constants'
require '../lib/player'
require 'yaml'
describe Board do
  include Constants
  subject(:default_board) { described_class.new }
  let(:white_king) { instance_double(King) }
  let(:black_king) { instance_double(King) }
  let(:white_queen) { instance_double(Queen) }
  let(:black_queen) { instance_double(Queen) }
  let(:white) { instance_double(Player) }
  let(:black) { instance_double(Player) }
  before do
    allow(white).to receive(:colour).and_return(:white)
    allow(black).to receive(:colour).and_return(:black)
    allow(white_king).to receive(:owner).and_return(white)
    allow(white_queen).to receive(:owner).and_return(white)
    allow(black_king).to receive(:owner).and_return(black)
    allow(black_king).to receive(:instance_of?).with(King).and_return(true)
    allow(black_queen).to receive(:owner).and_return(black)
  end
  matcher :place_equal do
    match { place }
  end
  describe '#initialize' do
    it 'initializes an array containing 8 arrays of 8 places' do
      expected_result = [[Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new]]
      result = default_board.instance_variable_get(:@board)
      expect(result).to eq(expected_result)
    end
  end

  describe '#legal?' do
    white =  Player.new(:white)
    white_king = King.new(white)
    black = Player.new(:black)
    black_king  = King.new(black)
    it 'Returns true for a legal king move' do
      legal_king_board = default_board.instance_variable_get(:@board)
      legal_king_board[4][4].instance_variable_set(:@piece, white_king)
      expect(default_board).to be_legal([[4, 4], [5, 5]], white)
    end

    it 'Returns false for an invalid king move' do
      legal_king_board = default_board.instance_variable_get(:@board)
      legal_king_board[4][4].instance_variable_set(:@piece, white_king)
      expect(default_board).not_to be_legal([[4, 4], [6, 6]], white)
    end

    it 'returns false for a king move that leaves it in check' do
      check_king_board = default_board.instance_variable_get(:@board)
      check_king_board[0][0].instance_variable_set(:@piece, white_king)
      check_king_board[0][2].instance_variable_set(:@piece, black_king)
      allow(default_board).to receive(:check_after_move?).and_return(true)
      expect(default_board).not_to be_legal([[0, 0], [0, 1]], white)
    end
    context 'When attempting to move another players piece' do
      subject(:wrong_piece_board) { described_class.new }
      it 'returns false' do
        board = wrong_piece_board.instance_variable_get(:@board)
        board[7][7].instance_variable_set(:@piece, black_king)
        expect(wrong_piece_board).not_to be_legal([[7, 7], [7, 6]], white)
      end
    end

    it 'Returns false when moving a nonexistant piece' do
      expect(default_board).not_to be_legal([[3, 3], [2, 2]], black)
    end

    context 'When a player attempts to move 2 of their pieces to the same place' do
      subject(:same_place_board) { described_class.new }
      it 'returns false' do
        board = same_place_board.instance_variable_get(:@board)
        board[4][4].instance_variable_set(:@piece, white_king)
        other_piece = instance_double(Piece)
        allow(other_piece).to receive(:owner).and_return(white)
        board[4][5].instance_variable_set(:@piece, other_piece)
        expect(same_place_board).not_to be_legal([[4, 4], [4, 5]], white)
      end
    end

    context 'When moving onto a square occupied by an enemy piece' do
      subject(:capture_board) { described_class.new }
      it 'returns true' do
        allow(capture_board).to receive(:check_after_move?).and_return(false)
        board = capture_board.instance_variable_get(:@board)
        board[4][4].instance_variable_set(:@piece, white_king)
        other_piece = instance_double(Piece)
        allow(other_piece).to receive(:owner).and_return(black)
        board[4][5].instance_variable_set(:@piece, other_piece)
        expect(capture_board).to be_legal([[4, 4], [5, 5]], white)
      end
    end
  end
  describe '#check' do
    subject(:check_board) { described_class.new }
    before do
      allow(black_king).to receive(:possible_moves).and_return([[1, 0]])
      allow(white_queen).to receive(:possible_moves).and_return([[1, 1]])
      allow(white_king).to receive(:possible_moves).and_return([[6, 6]])
    end
    it 'returns true if the given player is in check' do
      board = check_board.instance_variable_get(:@board)
      board[1][1].instance_variable_set(:@piece, black_king)
      board[7][7].instance_variable_set(:@piece, white_king)
      board[1][7].instance_variable_set(:@piece, white_queen)
      expect(check_board).to be_check(black)
    end

    it 'returns false if the given player is not is check' do
      board = check_board.instance_variable_get(:@board)
      board[2][3].instance_variable_set(:@piece, black_king)
      board[7][7].instance_variable_set(:@piece, white_king)
      board[1][7].instance_variable_set(:@piece, white_queen)
      expect(check_board).not_to be_check(black)
    end
  end
  describe '#checkmate' do
    subject(:checkmate_board) { described_class.new }
    let(:white_rook_one) { instance_double(Rook) }
    let(:black_rook) { instance_double(Rook) }
    before do
      allow(white_king).to receive(:possible_moves)
      allow(black_king).to receive(:possible_moves)
      allow(white_rook_one).to receive(:owner).and_return(white)
      allow(checkmate_board).to receive(:check?).and_return(true)
      allow(checkmate_board).to receive(:check_after_move?).and_return(true)
      allow(black_rook).to receive(:owner).and_return(black)
    end
    let(:white_rook_two) { white_rook_one.clone }
    it 'Returns true if players king is in check, and cannot move out' do
      board = checkmate_board.instance_variable_get(:@board)
      board[0][0].instance_variable_set(:@piece, black_king)
      board[7][0].instance_variable_set(:@piece, white_rook_one)
      board[7][1].instance_variable_set(:@piece, white_rook_two)
      board[7][7].instance_variable_set(:@piece, white_king)
      allow(black_king).to receive(:possible_moves).and_return([[1, 0], [1, 1], [0, 1]])
      allow(white_rook_one).to receive(:possible_moves).and_return([[1, 0], [0, 0]])
      allow(white_rook_two).to receive(:possible_moves).and_return([[1, 1], [0, 1]])
      allow(checkmate_board).to receive(:check_after_move?).and_return(true)
      expect(checkmate_board).to be_checkmate(black)
    end

    it 'Returns false if players king is in check, and can move out' do
      allow(black_queen).to receive(:possible_moves).and_return([[7, 7]])
      allow(white_king).to receive(:possible_moves).and_return([[6, 6], [6, 7]])
      board = checkmate_board.instance_variable_get(:@board)
      board[7][7].instance_variable_set(:@piece, white_king)
      board[1][3].instance_variable_set(:@piece, black_king)
      board[1][7].instance_variable_set(:@piece, black_queen)
      allow(checkmate_board).to receive(:check_after_move?).with([[7, 7], [6, 6]], white_king.owner).and_return(false)
      expect(checkmate_board).not_to be_checkmate(white)
    end

    it 'Returns false if players king is check, cannot move out and another piece can block check' do
      board = checkmate_board.instance_variable_get(:@board)
      board[0][0].instance_variable_set(:@piece, black_king)
      board[7][0].instance_variable_set(:@piece, white_rook_one)
      board[7][1].instance_variable_set(:@piece, white_rook_two)
      board[7][7].instance_variable_set(:@piece, white_king)
      board[2][7].instance_variable_set(:@piece, black_rook)
      allow(black_king).to receive(:possible_moves).and_return([[1, 0], [1, 1], [0, 1]])
      allow(white_rook_one).to receive(:possible_moves).and_return([[1, 0], [0, 0]])
      allow(white_rook_two).to receive(:possible_moves).and_return([[1, 1], [0, 1]])
      allow(black_rook).to receive(:possible_moves).and_return([[2, 0], [2, 1]])
      allow(checkmate_board).to receive(:check_after_move?).and_return(true)
      allow(checkmate_board).to receive(:check_after_move?).with([[2, 7], [2, 0]], black).and_return(false)
      expect(checkmate_board).not_to be_checkmate(black)
    end

    it 'Returns false if player is not in check' do
      allow(checkmate_board).to receive(:check?).and_return(false)
      board = checkmate_board.instance_variable_get(:@board)
      board[1][1].instance_variable_set(:@piece, black_king)
      board[7][7].instance_variable_set(:@piece, white_king)
      expect(checkmate_board).not_to be_checkmate(white)
    end
  end

  describe '#stalemate' do
    subject(:stalemate_board) { described_class.new }
    let(:board) { stalemate_board.instance_variable_get(:@board) }
    before do
      board[7][7].instance_variable_set(:@piece, black_king)
      board[6][7].instance_variable_set(:@piece, white_queen)
      board[7][6].instance_variable_set(:@piece, white_king)
      allow(black_king).to receive(:possible_moves).and_return([])
    end

    context 'When black is not in check' do
      before do
        allow(stalemate_board).to receive(:check?).with(black).and_return(false)
      end
      it 'Returns true when a player is not in check has no legal moves availible' do
        expect(stalemate_board).to be_stalemate(black)
      end
  
      it 'Returns false if a player has any legal move availible when not in check' do
        board[1][1].instance_variable_set(:@piece, black_queen)
        allow(black_queen).to receive(:possible_moves).and_return([[2, 2], [3, 3]])
        expect(stalemate_board).not_to be_stalemate(black)
      end
    end

    it 'Returns false if a player is in check' do
      white_queen_two = white_queen.clone
      allow(white_queen_two).to receive(:possible_moves).and_return([7, 7])
      board[7][1].instance_variable_set(:@piece, white_queen_two)
      board[1][1].instance_variable_set(:@piece, nil)
      allow(stalemate_board).to receive(:check?).with(black).and_return(true)
      expect(stalemate_board).not_to be_stalemate(black)
    end
  end

  describe '#check_after_move?' do
    subject(:after_board) { described_class.new }
    let(:board) { after_board.instance_variable_get(:@board) }
    before do
      board[3][3].instance_variable_set(:@piece, white_king)
      board[7][7].instance_variable_set(:@piece, black_king)
      board[4][7].instance_variable_set(:@piece, black_queen)
      allow(white_king).to receive(:possible_moves).and_return([[4, 3], [2, 3]])
      allow(black_queen).to receive(:possible_moves).and_return([[4, 3]])
      allow(black_king).to receive(:possible_moves).and_return([[6, 6], [7, 6]])
      allow(after_board).to receive(:move_piece)
    end
    it 'Returns true if player will be in check after a given move' do
      allow(after_board).to receive(:check?).with(white).and_return(true)
      expect(after_board).to be_check_after_move([[3, 3], [4, 3]], white)
    end

    it 'Returns false if player is not in check after a move' do
      allow(after_board).to receive(:check?).with(white).and_return(false)
      expect(after_board).not_to be_check_after_move([[3, 3], [2, 3]], white)
    end
  end
end
