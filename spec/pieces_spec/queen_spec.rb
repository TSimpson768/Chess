# frozen_string_literal: true

require_relative '../../lib/pieces/queen'
require_relative '../../lib/player'

describe Queen do
  describe '#possible_moves' do
    it 'Retuns all spaces beteen pos and edge of board in all 8 directions' do
      player = instance_double(Player)
      allow(player).to receive(:colour).and_return(:white)
      queen = described_class.new(player)
      board = instance_double(Board)
      allow(queen).to receive(:set_symbol)
      allow(board).to receive(:valid_pos?).and_return(true)
      allow(board).to receive(:check_after_move?).and_return(false)
      allow(board).to receive(:locate_piece).and_return(nil)
      pos = [3, 3]
      expected_result = [[4, 3], [5, 3], [6, 3], [7, 3], [4, 4], [5, 5], [6, 6],
                         [7, 7], [3, 4], [3, 5], [3, 6], [3, 7], [2, 4], [1, 5], [0, 6], [2, 3], [1, 3],
                         [0, 3], [2, 2], [1, 1], [0, 0], [3, 2], [3, 1], [3, 0], [4, 2], [5, 1], [6, 0]].sort
      result = queen.possible_moves(pos, board).sort
      expect(result).to eq(expected_result)
    end
  end
end
