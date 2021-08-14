require_relative '../lib/place'
require_relative '../lib/pieces/piece'
require_relative '../lib/player'

describe Place do
  describe '#exit_place' do
    let(:piece) { instance_double(Piece) }
    subject(:place) { described_class.new(piece) }
    before do
      allow(piece).to receive(:moved)
    end
    it 'calls moved on @piece' do
      expect(piece).to receive(:moved).once
      place.exit_place
    end

    it 'returns piece' do
      exited = place.exit_place
      expect(exited).to equal(piece)
    end
  end
end
