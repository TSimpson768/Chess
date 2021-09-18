require_relative '../../lib/strategy/enpassant'
describe EnPassant do
  subject(:enpassant) { described_class.new }
  let(:empty_board) {
    board = []
    8.times do
      row = []
      8.times do
        row.push(Place.new)
      end
      board.push(row)
    end
    board
  }
  let(:white) { instance_double(Player) }
  let(:black) { instance_double(Player) }
  let(:white_pawn) { instance_double(Pawn) }
  let(:black_pawn) { instance_double(Pawn) }
  before do
    allow(white_pawn).to receive(:owner).and_return(white)
    allow(white_pawn).to receive(:move)
    allow(black_pawn).to receive(:owner).and_return(black)
    allow(black_pawn).to receive(:move)
  end
  describe '#make_move' do
    it 'Executes a white en-passant move queenside' do
      empty_board[4][2].instance_variable_set(:@piece, white_pawn)
      empty_board[4][1].instance_variable_set(:@piece, black_pawn)
      expected_board = empty_board.map { |row| row.map(&:clone) }
      expected_board[4][2].instance_variable_set(:@piece, nil)
      expected_board[4][1].instance_variable_set(:@piece, nil)
      expected_board[5][1].instance_variable_set(:@piece, white_pawn)
      result = enpassant.make_move([[4, 2], [5, 1]], empty_board)
      expect(result).to eq(expected_board)
    end

    it 'Executes a white en-passant move kingside' do
      empty_board[4][2].instance_variable_set(:@piece, white_pawn)
      empty_board[4][3].instance_variable_set(:@piece, black_pawn)
      expected_board = empty_board.map { |row| row.map(&:clone) }
      expected_board[4][2].instance_variable_set(:@piece, nil)
      expected_board[4][3].instance_variable_set(:@piece, nil)
      expected_board[5][3].instance_variable_set(:@piece, white_pawn)
      result = enpassant.make_move([[4, 2], [5, 3]], empty_board)
      expect(result).to eq(expected_board)
    end

    it 'Executes a black ep move queenside' do
      empty_board[3][5].instance_variable_set(:@piece, black_pawn)
      empty_board[3][4].instance_variable_set(:@piece, white_pawn)
      expected_board = empty_board.map { |row| row.map(&:clone) }
      expected_board[3][5].instance_variable_set(:@piece, nil)
      expected_board[3][4].instance_variable_set(:@piece, nil)
      expected_board[2][4].instance_variable_set(:@piece, black_pawn)
      result = enpassant.make_move([[3, 5], [2, 4]], empty_board)
      expect(result).to eq(expected_board)
    end

    it 'Executes a black ep move kingside' do
      empty_board[3][5].instance_variable_set(:@piece, black_pawn)
      empty_board[3][6].instance_variable_set(:@piece, white_pawn)
      expected_board = empty_board.map { |row| row.map(&:clone) }
      expected_board[3][5].instance_variable_set(:@piece, nil)
      expected_board[3][6].instance_variable_set(:@piece, nil)
      expected_board[2][6].instance_variable_set(:@piece, black_pawn)
      result = enpassant.make_move([[3, 5], [2, 6]], empty_board)
      expect(result).to eq(expected_board)
    end
  end
end
