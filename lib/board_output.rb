module BoardOutput
    # Print the board to the console
    def print_board
      print_header
      print_divider
      @board.reverse.each_with_index do |row, index|
        print "#{self.class::ROWS - index} "
        print_row(row)
        print_divider
      end
    end

    private


  def print_row(row)
    print '|'
    row.each(&:print_place)
    puts ' '
  end

  def print_header
    puts '    A   B   C   D   E   F   G   H   '
  end

  def print_divider
    puts '==================================='
  end
end
