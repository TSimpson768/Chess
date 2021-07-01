require_relative '../../lib/pieces/pawn'

describe Pawn do

  describe '#possible_moves' do
    let(:white) { instance_double(Player) }
    let(:black) { instance_double(Player) }
    let(:empty_board) { instance_double(Board) }
    before do
      allow(white).to receive(:colour).and_return(:white)
      allow(black).to receive(:colour).and_return(:black)
      allow(empty_board).to receive(:valid_pos?).and_return(true)
      allow(empty_board).to receive(:check_after_move?).and_return(false)
      allow(empty_board).to receive(:locate_piece).and_return(nil)
    end
    context 'For a white pawn' do
      subject(:white_pawn) { described_class.new(white) }
      let(:black_pawn) { described_class.new(black) }
      before do
        allow(white_pawn).to receive(:set_symbol)
        allow(black_pawn).to receive(:set_symbol)
      end
      it 'Can move either 1 or 2 squares forward if it is on the second rank' do
        pos = [1, 3]
        expected_result = [[2, 3], [3, 3]]
        result = white_pawn.possible_moves(pos, empty_board)
        expect(result).to eq(expected_result)
      end

      it 'can move only one square forward on third - 7th ranks' do
        pos = [3, 3]
        expected_result = [[4, 3]]
        result = white_pawn.possible_moves(pos, empty_board)
        expect(result).to eq(expected_result)
      end

      it 'Can move diagonaly up a rank and a file to capture a piece' do
        pos = [3, 3]
        allow(empty_board).to receive(:locate_piece).with([4, 4]).and_return(black_pawn)
        expected_result = [[4, 3], [4, 4]]
        result = white_pawn.possible_moves(pos, empty_board)
        expect(result).to eq(expected_result)
      end
  
      xit 'Can move diagonaly up a rank and down a file to capture a piece' do
        
      end
  
      xit 'Can capture an opposing pawn that has just moved 2 places on passent' do
        
      end
    end
  
    context 'For a black pawn' do
      xit ' Can move down either 1 or 2 ranks if it is on the 7th rank' do
        
      end
  
      xit 'Can move only one square down rank on th 6th to 2nd ranks' do
        
      end
  
      xit 'Can move diagonaly down a rank and a file to capture a piece' do
        
      end
  
      xit 'Can move diagonaly down a rank and uo a file to capture a piece' do
        
      end
  
      xit 'Can capture an opposing pawn that has just moved 2 places on passent' do
        
      end
    end
  end
end
