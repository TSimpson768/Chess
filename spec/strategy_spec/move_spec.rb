require_relative '../../lib/strategy/move'
require 'pry'
describe Move do
  subject(:move) { described_class.new }
  let(:board) { instance_double(Board) }
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
  let(:white_queen) { instance_double(Queen) }
  let(:black_rook) { instance_double(Rook) }
  before do
    board.instance_variable_set(:@board, empty_board)
    allow(black_rook).to receive(:move)
    allow(white_queen).to receive(:move)
  end
  describe '#make_move' do
    it 'correctly moves a piece to an empty space' do
      empty_board[7][7].instance_variable_set(:@piece, black_rook)
      expected_board = empty_board.map { |row| row.map(&:clone) }
      expected_board[7][7].instance_variable_set(:@piece, nil)
      expected_board[7][0].instance_variable_set(:@piece, black_rook)
      result = move.make_move([[7, 7], [7, 0]], empty_board)
      expect(result).to eq expected_board
    end

    it 'correctly executes a capture' do
      empty_board[6][5].instance_variable_set(:@piece, black_rook)
      empty_board[3][2].instance_variable_set(:@piece, white_queen)
      expected_board = empty_board.map { |row| row.map(&:clone) }
      expected_board[6][5].instance_variable_set(:@piece, white_queen)
      expected_board[3][2].instance_variable_set(:@piece, nil)
      result = move.make_move([[3, 2], [6, 5]], empty_board)
      expect(result).to eq(empty_board)
    end
  end
end
