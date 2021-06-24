require '../lib/moveList'
require '../lib/player'
require '../lib/board'
require '../lib/piece'

describe MoveList do
  describe '#valid_moves' do
    subject(:valid_movelist) { described_class.new([1, 0], true) }

    context 'On an empty board' do
      it 'Returns all spaces between starting_position and board edge' do
        starting_position = [3, 3]
        board = instance_double(Board)
        owner = instance_double(Player)
        allow(board).to receive(:locate_piece).and_return(nil)
        expected_result = [[4, 3], [5, 3], [6, 3], [7, 3]]
        result = valid_movelist.valid_moves(starting_position, board, owner)
        expect(result).to eq expected_result
      end
    end

    context 'With a friendly piece on its path' do
      it 'Returns spaces between starting position and the friendly piece exclusive' do
        starting_position = [3, 3]
        board = instance_double(Board)
        owner = instance_double(Player)
        piece = instance_double(Piece)
        allow(board).to receive(:locate_piece)
        allow(board).to receive(:locate_piece).with([6, 3]).and_return(piece)
        allow(piece).to receive(:owner).and_return(owner)
        expected_result = [[4, 3], [5, 3]]
        result = valid_movelist.valid_moves(starting_position, board, owner)
        expect(result).to eq(expected_result)
      end
    end

    context 'With an enemy piece on its path' do
      it 'Returns spaces between starting position and the enemy piece inclusive' do
        starting_position = [3, 3]
        board = instance_double(Board)
        owner = instance_double(Player)
        opponent = instance_double(Player)
        piece = instance_double(Piece)
        allow(board).to receive(:locate_piece)
        allow(board).to receive(:locate_piece).with([6, 3]).and_return(piece)
        allow(piece).to receive(:owner).and_return(opponent)
        expected_result = [[4, 3], [5, 3], [6, 3]]
        result = valid_movelist.valid_moves(starting_position, board, owner)
        expect(result).to eq(expected_result)
      end
    end
  end
end