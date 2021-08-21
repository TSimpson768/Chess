# frozen_string_literal: true

require_relative '../../lib/pieces/rook'

describe Rook do
  subject(:rook) { described_class.new }
  it 'Returns all possible moves from center of board to the edge on an empty board' do
    player = instance_double(Player)
    allow(player).to receive(:colour).and_return(:white)
    rook = described_class.new(player)
    board = instance_double(Board)
    allow(rook).to receive(:set_symbol)
    allow(board).to receive(:valid_pos?).and_return(true)
    allow(board).to receive(:check_after_move?).and_return(false)
    allow(board).to receive(:locate_piece).and_return(nil)
    pos = [3, 3]
    expected_result = [[0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3],
                       [3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7]].sort
    result = rook.possible_moves(pos, board).sort
    expect(result).to eq(expected_result)
  end
end
