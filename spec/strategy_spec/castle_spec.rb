require_relative '../../lib/strategy/castle'
describe Castle do
  subject(:castle) { described_class.new }
  let(:empty_board) do
    board = []
    8.times do
      row = []
      8.times do
        row.push(Place.new)
      end
      board.push(row)
    end
    board
  end
  let(:white) { instance_double(Player) }
  let(:black) { instance_double(Player) }
  let(:white_king) { instance_double(King) }
  let(:black_king) { instance_double(King) }
  let(:white_rook) { instance_double(Rook) }
  let(:black_rook) { instance_double(Rook) }
  before do
    allow(white_king).to receive(:move)
    allow(white_king).to receive(:owner).and_return(white)
    allow(black_king).to receive(:owner).and_return(black)
    allow(white_rook).to receive(:move)
    allow(black_king).to receive(:move)
    allow(black_rook).to receive(:move)
    allow(white).to receive(:can_castle=)
    allow(black).to receive(:can_castle=)
  end
  describe '#make_move' do
    it 'Castles white kingside' do
      empty_board[0][7].instance_variable_set(:@piece, white_rook)
      empty_board[0][4].instance_variable_set(:@piece, white_king)
      expected_board = empty_board.map { |row| row.map(&:clone) }
      expected_board[0][6].instance_variable_set(:@piece, white_king)
      expected_board[0][4].instance_variable_set(:@piece, nil)
      expected_board[0][7].instance_variable_set(:@piece, nil)
      expected_board[0][5].instance_variable_set(:@piece, white_rook)
      result = castle.make_move([[0, 4], [0, 6]], empty_board)
      expect(result).to eq expected_board
    end

    it 'Castles white queenside' do
      empty_board[0][0].instance_variable_set(:@piece, white_rook)
      empty_board[0][4].instance_variable_set(:@piece, white_king)
      expected_board = empty_board.map { |row| row.map(&:clone) }
      expected_board[0][2].instance_variable_set(:@piece, white_king)
      expected_board[0][4].instance_variable_set(:@piece, nil)
      expected_board[0][0].instance_variable_set(:@piece, nil)
      expected_board[0][3].instance_variable_set(:@piece, white_rook)
      result = castle.make_move([[0, 4], [0, 2]], empty_board)
      expect(result).to eq expected_board
    end

    it 'castles black kingside' do
      expected_board = empty_board.map { |row| row.map(&:clone) }
      empty_board[7][7].instance_variable_set(:@piece, black_rook)
      empty_board[7][4].instance_variable_set(:@piece, black_king)
      expected_board[7][6].instance_variable_set(:@piece, black_king)
      expected_board[7][5].instance_variable_set(:@piece, black_rook)
      result = castle.make_move([[7, 4], [7, 6]], empty_board)
      expect(result).to eq(expected_board)
    end

    it 'castles black queenside' do
      expected_board = empty_board.map { |row| row.map(&:clone) }
      empty_board[7][0].instance_variable_set(:@piece, black_rook)
      empty_board[7][4].instance_variable_set(:@piece, black_king)
      expected_board[7][2].instance_variable_set(:@piece, black_king)
      expected_board[7][3].instance_variable_set(:@piece, black_rook)
      result = castle.make_move([[7, 4], [7, 2]], empty_board)
      expect(result).to eq(expected_board)
    end
  end
end
