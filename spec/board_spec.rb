require '../lib/board'
require '../lib/place'
require 'yaml'
describe Board do
  subject(:default_board) { described_class.new }
  matcher :place_equal do
    match {place }
  end
  describe '#initialize' do
    # HACK? - I want to compare object contents only, not identity
    it 'initializes an array containing 8 arrays of 8 places' do
      expected_result = [[Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new],
                         [Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new, Place.new]]
      expected_result = YAML.dump(expected_result)
      result = YAML.dump(default_board.instance_variable_get(:@board))
      expect(result).to eq(expected_result)
    end
  end
end