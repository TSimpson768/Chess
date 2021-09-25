module BoardOutput
  # Print the board to the console
  def initialize
    @colour = :black
  end

  def print_board
    print_header
    @board.reverse.each_with_index do |row, index|
      print_divider
      print "#{self.class::ROWS - index} "
      print_row(row)
      print_divider
      change_colour
    end
    print "\e[39;49m"
  end

  private

  def print_row(row)
    row.each do |place|
      change_colour
      print ' '
      place.print_place
      print ' '
    end
    print "\e[39;49m\n"
  end

  def print_header
    puts '    A    B    C    D    E    F    G    H   '
  end

  def print_divider
    print "\e[39;49m  "
    8.times do
      change_colour
      print '     '
    end
    print "\e[39;49m\n"
  end

  def change_colour
    if @background_colour == :white
      print "\e[30;47m"
      @background_colour = :black
    else
      print "\e[37;40m"
      @background_colour = :white
    end
  end

  def current_colour
    if @background_colour == :white
      print "\e[37;40m"
    else
      print "\e[30;47m"
    end
  end
end
