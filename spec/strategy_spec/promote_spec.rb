require_relative '../../lib/strategy/promote'
require_relative '../../lib/player'
require_relative '../../lib/pieces/pawn'
describe Promote do
  subject(:promote) { described_class.new }
  let(:white_pawn) { instance_double(Pawn) }
  let(:black_pawn) { instance_double(Pawn) }
  let(:white_queen) { instance_double(Queen) }
  let(:black_queen) { instance_double(Queen) }
  let(:white) { instance_double(Player) }
  let(:black) { instance_double(Player) }
  before do
    allow(white).to receive(:colour).and_return(:white)
    allow(white_pawn).to receive(:move)
    allow(white_pawn).to receive(:owner).and_return(white)
    allow(white_queen).to receive(:owner).and_return(white)
    allow(black_pawn).to receive(:move)
    allow(black_pawn).to receive(:owner).and_return(black)
  end
  describe '#make_move' do
    let(:empty_board) do
      board = []
      8.times do
        row = []
        8.times do
          row.push(Place.new)
        end
        board.push(row)
      end
      board
    end

    it 'Promotes a white pawn moving on to an 8th rank empty space' do
      expected_board = empty_board.map { |row| row.map(&:clone) }
      empty_board[6][0].instance_variable_set(:@piece, white_pawn)
      expected_board[7][0].instance_variable_set(:@piece, white_queen)
      allow(promote).to receive(:solicit_promotion).and_return(white_queen)
      result = promote.make_move([[6, 0], [7, 0]], empty_board)
      expect(result).to eq expected_board
    end

    it 'Promotes a black pawn moving on to the 1st rank' do
      expected_board = empty_board.map { |row| row.map(&:clone) }
      empty_board[1][3].instance_variable_set(:@piece, black_pawn)
      expected_board[0][3].instance_variable_set(:@piece, black_queen)
      allow(promote).to receive(:solicit_promotion).and_return(black_queen)
      result = promote.make_move([[1, 3], [0, 3]], empty_board)
      expect(result).to eq expected_board
    end
  end

  describe '#solicit_promotion' do
    before do
      allow(promote).to receive(:puts)
    end
    it 'Returns a queen owned by moving player if player inputs Q' do
      allow(promote).to receive(:input_promotion).and_return('Q')
      allow(Queen).to receive(:new).and_return(white_queen)
      result = promote.solicit_promotion(white_pawn)
      expect(result).to eq white_queen
      expect(result.owner).to eq(white_pawn.owner)
    end

    it 'Returns a rook owned by moving player if player inputs R' do
      black_rook = instance_double(Rook)
      allow(black_rook).to receive(:owner).and_return(black)
      allow(promote).to receive(:input_promotion).and_return('R')
      allow(Rook).to receive(:new).and_return(black_rook)
      result = promote.solicit_promotion(black_pawn)
      expect(result).to eq(black_rook)
      expect(result.owner).to eq(black_pawn.owner)
    end

    it 'Returns a bishop owned by moving player if player inputs B' do
      white_bishop = instance_double(Bishop)
      allow(white_bishop).to receive(:owner).and_return(white)
      allow(promote).to receive(:input_promotion).and_return('B')
      allow(Bishop).to receive(:new).with(white, true).and_return(white_bishop)
      result = promote.solicit_promotion(white_pawn)
      expect(result).to eq(white_bishop)
    end

    it 'Returns a knight owned by moving player if player inputs K' do
      black_knight = instance_double(Knight)
      allow(black_knight).to receive(:owner).and_return(black)
      allow(promote).to receive(:input_promotion).and_return('K')
      allow(Knight).to receive(:new).with(black, true).and_return(black_knight)
      result = promote.solicit_promotion(black_pawn)
      expect(result).to eq(black_knight)
    end
  end
end
