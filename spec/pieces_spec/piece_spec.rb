# frozen_string_literal: true

require_relative '../../lib/pieces/piece'

describe Piece do
  let(:white) { instance_double(Player) }
  before do
    allow(white).to receive(:colour)
  end
  describe '#moved' do
    context 'When a piece has not moved' do
      subject(:unmoved) { described_class.new(white, false) }
      it 'sets @moved to true if moved is false' do
        unmoved.move
        moved = unmoved.instance_variable_get(:@moved)
        expect(moved).to eq true
      end
    end

    context 'When a piece has moved (@moved = true)' do
      subject(:moved_piece) { described_class.new(white, true) }
      it 'keeps @moved = true' do
        moved_piece.move
        has_moved = moved_piece.instance_variable_get(:@moved)
        expect(has_moved).to eq true
      end
    end
  end
end
