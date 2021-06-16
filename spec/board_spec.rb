require '../lib/board'
require '../lib/place'
require '../lib/piece'
require '../lib/king'
require '../lib/constants'
require '../lib/player'
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
    white =  Player.new(:white)
    white_king = King.new(white)
    black = Player.new(:black)
    black_king  = King.new(black)
    it 'Returns true for a legal king move' do
      legal_king_board = default_board.instance_variable_get(:@board)
      legal_king_board[4][4].instance_variable_set(:@piece, white_king)
      expect(default_board).to be_legal([[4, 4], [5, 5]], white)
    end

    it 'Returns false for an invalid king move' do
      legal_king_board = default_board.instance_variable_get(:@board)
      legal_king_board[4][4].instance_variable_set(:@piece, white_king)
      expect(default_board).not_to be_legal([[4, 4], [6, 6]], white)
    end

    it 'returns false for a king move that leaves it in check' do
      check_king_board = default_board.instance_variable_get(:@board)
      check_king_board[0][0].instance_variable_set(:@piece, white_king)
      check_king_board[0][2].instance_variable_set(:@piece, black_king)
      allow(default_board).to receive(:check?).and_return(true)
      expect(default_board).not_to be_legal([[0, 0], [0, 1]], white)
    end
    context 'When attempting to move another players piece' do
      subject(:wrong_piece_board) { described_class.new }
      it 'returns false' do
        board = wrong_piece_board.instance_variable_get(:@board)
        board[7][7].instance_variable_set(:@piece, black_king)
        expect(wrong_piece_board).not_to be_legal([[7, 7], [7, 6]], white)
      end
    end


    xit 'Returns false when moving a nonexistant piece' do
      
    end
  end
end
