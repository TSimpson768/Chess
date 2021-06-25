require_relative '../../lib/pieces/king'
require_relative '../../lib/player'

describe King do
  describe '#possible_moves' do
    it 'Returns all 8 surrounding spaces at the centre of an empty board' do
      player = instance_double(Player)
      allow(player).to receive(:colour).and_return(:white)
      king = described_class.new(player)
      allow(king).to receive(:set_symbol)
      board = instance_double(Board)
      allow(board).to receive(:valid_pos?).and_return(true)
      allow(board).to receive(:check_after_move?).and_return(false)
      allow(board).to receive(:locate_piece).and_return(nil)
      starting_position = [3, 3]
      expected_result = [[4, 3], [4, 4], [4, 2], [3, 2], [3, 4], [2, 2], [2, 3], [2, 4]].sort
      result = king.possible_moves(starting_position, board).sort
      expect(result).to eq(expected_result)
    end
  end
end
