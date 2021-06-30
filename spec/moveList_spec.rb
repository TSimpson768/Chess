require '../lib/moveList'
require '../lib/player'
require '../lib/board'
require_relative '../lib/pieces/piece'

describe MoveList do
  describe '#valid_moves' do
    subject(:valid_movelist) { described_class.new([1, 0], true) }

    context 'On an empty board' do
      it 'Returns all spaces between starting_position and board edge' do
        starting_position = [3, 3]
        board = instance_double(Board)
        owner = instance_double(Player)
        allow(board).to receive(:locate_piece).and_return(nil)
        allow(board).to receive(:check_after_move?).and_return(false)
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
        allow(board).to receive(:check_after_move?).and_return(false)
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
        allow(board).to receive(:check_after_move?).and_return(false)
        allow(piece).to receive(:owner).and_return(opponent)
        expected_result = [[4, 3], [5, 3], [6, 3]]
        result = valid_movelist.valid_moves(starting_position, board, owner)
        expect(result).to eq(expected_result)
      end
    end

    context 'For a non-sliding piece (pawn, knight, king)' do
      subject(:non_sliding_movelist) { described_class.new([0, 1], false) }
      it 'Returns only one move on an empty board' do
        starting_position = [0, 0]
        board = instance_double(Board)
        owner = instance_double(Player)
        allow(board).to receive(:locate_piece)
        allow(board).to receive(:valid_pos?).and_return(true)
        allow(board).to receive(:check_after_move?).and_return(false)
        expected_result = [[0, 1]]
        result = non_sliding_movelist.valid_moves(starting_position, board, owner)
        expect(result).to eq(expected_result)
      end

      it 'Returns no moves if the target space is occupied by a friendly piece' do
        starting_position = [0, 0]
        board = instance_double(Board)
        owner = instance_double(Player)
        piece = instance_double(Piece)
        allow(board).to receive(:locate_piece)
        allow(board).to receive(:locate_piece).with([0, 1]).and_return(piece)
        allow(board).to receive(:valid_pos?).and_return(true)
        allow(board).to receive(:valid_pos?).with([0, 1], owner).and_return(false)
        allow(board).to receive(:check_after_move?).and_return(false)
        allow(piece).to receive(:owner).and_return(owner)
        result = non_sliding_movelist.valid_moves(starting_position, board, owner)
        expect(result).to eq([])
      end

      it 'Returns the move if target space is occupied by an enemy piece' do
        starting_position = [0, 0]
        board = instance_double(Board)
        owner = instance_double(Player)
        piece = instance_double(Piece)
        opponent = instance_double(Player)
        allow(board).to receive(:locate_piece)
        allow(board).to receive(:locate_piece).with([0, 1]).and_return(piece)
        allow(board).to receive(:valid_pos?).and_return(true)
        allow(board).to receive(:check_after_move?).and_return(false)
        allow(piece).to receive(:owner).and_return(opponent)
        expected_result = [[0, 1]]
        result = non_sliding_movelist.valid_moves(starting_position, board, owner)
        expect(result).to eq(expected_result)
      end

      it 'Returns false if that move is out of bounds' do
        starting_position = [0, 7]
        board = instance_double(Board)
        owner = instance_double(Player)
        allow(board).to receive(:locate_piece)
        allow(board).to receive(:valid_pos?).with([0, 8], owner).and_return(false)
        allow(board).to receive(:check_after_move?).and_return(false)
        expected_result = []
        result = non_sliding_movelist.valid_moves(starting_position, board, owner)
        expect(result).to eq(expected_result)
      end
    end
  end
end