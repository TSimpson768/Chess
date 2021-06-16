require '../lib/board'
require '../lib/place'
require '../lib/piece'
require '../lib/king'
require '../lib/constants'
require 'yaml'
describe Board do
  include Constants
  subject(:default_board) { described_class.new }
  matcher :place_equal do
    match { place }
  end
  describe '#initialize' do
    it 'initializes an array containing 8 arrays of 8 places' do
      expected_result = [[Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new]]
      result = default_board.instance_variable_get(:@board)
      expect(result).to eq(expected_result)
    end
  end

  describe '#legal?' do
    it 'Returns true for a legal king move' do
      legal_king_board = default_board.instance_variable_get(:@board)
      legal_king_board[4][4].instance_variable_set(:@piece, King.new(Player.new(:white)))
      expect(default_board).to be_legal([[4, 4], [5, 5]])
    end

    xit 'Returns false for an invalid king move' do
      
    end

    xit 'returns false for a king move that leaves it in check' do
      
    end

    xit 'returns false when attempting to move the other players piece' do
      
    end

    xit 'Returns false when moving a nonexistant piece' do
      
    end
  end
end
