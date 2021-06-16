require '../lib/game'
describe Game do
  subject(:game_default) { described_class.new }

  describe '#make_move' do
    context 'when a legal move is received' do
      xit 'calls @board.move with it'
    end
  end
  describe '#input_move' do
    context 'When valid move A1 to A2 is input' do
      subject(:game_valid_a) { described_class.new }
      before do
        allow(game_valid_a).to receive(:gets).and_return("A1A2\n")
      end
      it 'returns that move' do
        result = game_valid_a.input_move
        expect(result).to eq([[0, 0], [0, 1]])
      end
    end

    context 'When valid move B3 to C4 is input' do
      subject(:game_valid_b) { described_class.new }
      before do
        allow(game_valid_b).to receive(:gets).and_return("b3c4\n")
      end
      it 'returns that move do' do
        result = game_valid_b.input_move
        expect(result).to eq([[1, 2], [2, 3]])
      end
    end

    context 'When 2 invalid (correctly formatted) moves, followed by a valid move is input' do
      xit 'puts an error message twice' do
        
      end

      xit 'Returns the valid move' do
        
      end
    end
  end
end
