require_relative '../../lib/pieces/knight'

describe Knight do
  it 'Returns all possible knight moves' do
    player = instance_double(Player)
    allow(player).to receive(:colour).and_return(:white)
    knight = described_class.new(player)
    board = instance_double(Board)
    allow(knight).to receive(:set_symbol)
    allow(board).to receive(:valid_pos?).and_return(true)
    allow(board).to receive(:check_after_move?).and_return(false)
    allow(board).to receive(:locate_piece).and_return(nil)
    pos = [3, 3]
    expected_result = [[5, 4], [5, 2], [4, 5], [2, 5], [4, 1], [2, 1], [1, 4], [1, 2]].sort
    result = knight.possible_moves(pos, board).sort
    expect(result).to eq(expected_result)
  end
end
