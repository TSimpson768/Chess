require '../lib/game'
describe Game do
  subject(:game_default) { described_class.new }
  describe '#switch_players' do
    context 'When the current_player is white' do
      white = nil
      black = nil
      before do
        white = game_default.instance_variable_get(:@current_player)
        black = game_default.instance_variable_get(:@opposing_player)
      end
      it 'sets black as the current player' do
        game_default.switch_players
        new_current = game_default.instance_variable_get(:@current_player)
        expect(new_current).to equal(black)
      end

      it 'sets white as the oposing player' do
        game_default.switch_players
        new_opposing = game_default.instance_variable_get(:@opposing_player)
        expect(new_opposing).to equal(white)
      end
    end

    context 'When black is the current player' do
      white = nil
      black = nil
      before do
        white = game_default.instance_variable_get(:@current_player)
        black = game_default.instance_variable_get(:@opposing_player)
        game_default.instance_variable_set(:@current_player, black)
        game_default.instance_variable_set(:@opposing_player, white)
      end
      it 'sets white as the current player' do
        game_default.switch_players
        new_current = game_default.instance_variable_get(:@current_player)
        expect(new_current).to equal(white)
      end

      it 'Sets black as the opposing player' do
        game_default.switch_players
        new_opposing = game_default.instance_variable_get(:@opposing_player)
        expect(new_opposing).to equal(black)
      end
    end
  end

  describe '#make_move' do
    context 'when a legal move is received' do
      subject(:legal_game) { described_class.new }
      legal_move = [[1, 3], [2, 4]]
      before do
        allow(legal_game).to receive(:input_move).and_return(legal_move)
      end
      it 'calls @board.move with it' do
        legal_board = instance_double(Board)
        allow(legal_board).to receive(:legal?).and_return(true)
        allow(legal_board).to receive(:move_piece)
        legal_game.instance_variable_set(:@board, legal_board)

        expect(legal_board).to receive(:move_piece).with(legal_move)
        legal_game.make_move
      end
    end

    context 'When an illegal move, followed by a legal move is received' do
      subject(:illegal_game) { described_class.new }
      illegal_move = [[0, 0], [6, 7]]
      legal_move = [[3, 0], [1, 0]]
      before do
        illegal_board = instance_double(Board)
        allow(illegal_board).to receive(:legal?).and_return(false, true)
        allow(illegal_board).to receive(:move_piece)
        illegal_game.instance_variable_set(:@board, illegal_board)
        allow(illegal_game).to receive(:input_move).and_return(illegal_move, legal_move)
        allow(illegal_game).to receive(:puts)
      end
      it 'puts an error message once' do
        illegal_message = 'Please enter a legal move'
        expect(illegal_game).to receive(:puts).with(illegal_message).once
        illegal_game.make_move
      end

      it 'calls @board.move with the legal move' do
        illegal_board = illegal_game.instance_variable_get(:@board)
        expect(illegal_board).to receive(:move_piece).with(legal_move)
        illegal_game.make_move
      end
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
        expect(result).to eq([[0, 0], [1, 0]])
      end
    end

    context 'When valid move B3 to C4 is input' do
      subject(:game_valid_b) { described_class.new }
      before do
        allow(game_valid_b).to receive(:gets).and_return("b3c4\n")
      end
      it 'returns that move do' do
        result = game_valid_b.input_move
        expect(result).to eq([[2, 1], [3, 2]])
      end
    end

    context 'When 2 invalid (correctly formatted) moves, followed by a valid move is input' do
      subject(:game_invalid) { described_class.new }
      before do
        allow(game_invalid).to receive(:gets).and_return("Lizard\n", "J9k9\n", "A1h8\n")
      end

      it 'puts an error message twice' do
        error_message = "I don't understand that. Please input a move in format [starting square][destination]
 I.e. to move the piece at A1 to D4, type A1D4"
        expect(game_invalid).to receive(:puts).with(error_message).twice
        game_invalid.input_move
      end

      it 'Returns the valid move' do
        result = game_invalid.input_move
        expect(result).to eq([[0, 0], [7, 7]])
      end
    end
  end
end
