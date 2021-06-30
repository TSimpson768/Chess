require_relative '../../lib/pieces/bishop'

describe Bishop do
  describe '#possible_moves' do
    it 'Returns all the moves a bishop can make' do
      player = instance_double(Player)
      allow(player).to receive(:colour).and_return(:white)
      bishop = described_class.new(player)
      board = instance_double(Board)
      allow(bishop).to receive(:set_symbol)
      allow(board).to receive(:valid_pos?).and_return(true)
      allow(board).to receive(:check_after_move?).and_return(false)
      allow(board).to receive(:locate_piece).and_return(nil)
      pos = [3, 3]
      expected_result = [[0, 0], [1, 1], [2, 2], [4, 4], [5, 5], [6, 6], [7, 7],
                         [6, 0], [5, 1], [4, 2], [2, 4], [1, 5], [0, 6]].sort
      result = bishop.possible_moves(pos, board).sort
      expect(result).to eq(expected_result)
    end
  end
end