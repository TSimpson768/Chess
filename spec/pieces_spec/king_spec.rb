# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/player'

describe King do
  let(:player) { instance_double(Player) }
  subject(:king) { described_class.new(player) }
  let(:board) { instance_double(Board) }
  before do
    allow(player).to receive(:colour).and_return(:white)
    allow(player).to receive(:check)
    allow(king).to receive(:set_symbol)
    allow(king).to receive(:owner).and_return(:white)
    allow(board).to receive(:valid_pos?).and_return(true)
    allow(board).to receive(:check?)
    allow(player).to receive(:can_castle=)
  end
  describe '#possible_moves' do
    it 'Returns all 8 surrounding spaces at the centre of an empty board' do
      allow(board).to receive(:check_after_move?).and_return(false)
      allow(board).to receive(:locate_piece).and_return(nil)
      starting_position = [3, 3]
      expected_result = [[4, 3], [4, 4], [4, 2], [3, 2], [3, 4], [2, 2], [2, 3], [2, 4]].sort
      result = king.possible_moves(starting_position, board).sort
      expect(result).to eq(expected_result)
    end
    let(:castle_board) { instance_double(Board) }
    let(:qside_rook) { instance_double(Rook) }
    let(:kside_rook) { instance_double(Rook) }
    before do
      allow(castle_board).to receive(:locate_piece)
      allow(castle_board).to receive(:locate_piece).with([0, 0]).and_return(qside_rook)
      allow(castle_board).to receive(:locate_piece).with([0, 7]).and_return(kside_rook)
      allow(castle_board).to receive(:valid_pos?).and_return(true)
      allow(castle_board).to receive(:check?)
      allow(castle_board).to receive(:check_after_move?)
      allow(qside_rook).to receive(:owner).and_return(player)
      allow(qside_rook).to receive(:moved).and_return(false)
      allow(kside_rook).to receive(:owner).and_return(player)
      allow(kside_rook).to receive(:moved).and_return(false)
    end
    it 'Returns the castling moves if the king has not moved, and both of a players rooks have not moved' do
      allow(castle_board).to receive(:check_after_move?)
      starting_position = [0, 4]
      expected_result = [[0, 2], [0, 3], [1, 3], [1, 4], [1, 5], [0, 5], [0, 6]].sort
      result = king.possible_moves(starting_position, castle_board).sort
      expect(result).to eq(expected_result)
    end

    it 'Only returns normal moves if king has previously moved' do
      starting_position = [0, 4]
      expected_result = [[0, 3], [1, 3], [1, 4], [1, 5], [0, 5]].sort
      king.instance_variable_set(:@moved, true)
      result = king.possible_moves(starting_position, castle_board).sort
      expect(result).to eq(expected_result)
    end

    it 'Returns only normal moves if king is in check, but castling is otherwise possible' do
      starting_position = [0, 4]
      expected_result = [[0, 3], [1, 3], [1, 4], [1, 5], [0, 5]].sort
      allow(player).to receive(:check).and_return(true)
      allow(castle_board).to receive(:check?).and_return(true)
      result = king.possible_moves(starting_position, castle_board).sort
      expect(result).to eq(expected_result)
    end

    it 'Does not return a castle move if that rook has previously moved' do
      starting_position = [0, 4]
      expected_result = [[0, 3], [1, 3], [1, 4], [1, 5], [0, 5], [0, 6]].sort
      allow(qside_rook).to receive(:moved).and_return(true)
      result = king.possible_moves(starting_position, castle_board).sort
      expect(result).to eq(expected_result)
    end
  end
end
