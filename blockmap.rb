require 'constants'

module FloodPuzzle
  # Block Map
  class BlockMap
    include Constants

    attr_reader :optimal

    def initialize( easier = false )
      setup_random
      setup_easier if easier

      @original_blocks = copy_blocks

      calculate_minimal_flips

      @tlc = @blocks[0][0]
    end

    # Reset to the original created layout

    def reset
      @blocks = @original_blocks
    end

    # Generate the block colours entirely randomly

    def setup_random
      @blocks = Array.new( ROWS ) do
        Array.new( COLUMNS ) { rand( COLOR_TABLE.size ) }
      end
    end

    # Set up a slightly easier playing field. One in seven of the blocks will be
    # the same colour as its neighbour above or to the left

    def setup_easier
      (1...ROWS).each do |y|
        (1...COLUMNS).each do |x|
          set_neighbour_colour( x, y ) if rand( -1...COLOR_TABLE.size ) == -1
        end
      end
    end

    # Randomly choose either the block above or left to copy the colour from.

    def set_neighbour_colour( x, y )
      xd = rand( 2 )
      @blocks[y][x] = @blocks[y - (1 - xd)][x - xd]
    end

    # Change the colour of the blocks rooted at the top-left corner.

    def change_colour( colour )
      # Return false if the top-left colour is already the colour requested

      return false if @tlc == colour

      build_block_list

      # Debugging 'Auto' button

      colour = best_colour if colour >= COLOR_TABLE.size

      @tl_list.each { |x, y| @blocks[y][x] = colour }
      @tlc = @blocks[0][0]

      true    # Changed colours
    end

    # Every block the same colour?

    def game_over?
      @blocks.each do |row|
        return false if row.any? { |col| col != @tlc }
      end

      true
    end

    # Draw the blocks

    def draw( window )
      ROWS.times do |y|
        COLUMNS.times do |x|
          Block.draw( window, GridPoint.new( x, y ), COLOR_TABLE[@blocks[y][x]] )
        end
      end
    end

    private

    # Copy blocks so that they can be returned to later on, for example
    # after calculating the optimal number of flips

    def copy_blocks
      @blocks.map( &:dup )
    end

    # Calculate the minimal number of flips necessary to finish the current grid.
    # Actually, it's not quite optimal, since I've beaten it several times!

    def calculate_minimal_flips
      @optimal = 0

      until game_over?
        change_colour( best_colour )
        @optimal += 1
      end

      reset
    end

    # Try to calculate what the best colour to change to would be, based on
    # the number of blocks collected by changing to that colour.

    def best_colour
      build_block_list

      edges = []

      @tl_list.each do |x, y|
        neighbours( x, y ).each do |c, r|
          col = @blocks[r][c]
          edges << [col, c, r] if col != @tlc && !edges.include?( [col, c, r] )
        end
      end

      max_colour_count( edges )
    end

    def max_colour_count( edge_blocks )
      counts = Array.new( COLOR_TABLE.size, 0 )

      edge_blocks.each { |col, _, _| counts[col] += 1 }
      counts.index( counts.max )
    end

    # Build the list of positions in the block that is contiguous with the
    # top-left corner and the same colour as it is

    def build_block_list
      @tl_list = [[0, 0]]

      @tl_list.each do |x, y|
        neighbours( x, y ).each { |c, r| @tl_list << [c, r] if candidate?( c, r ) }
      end
    end

    # Return a list of the in-grid neighbours of the passed position

    def neighbours( x, y )
      neigh = []

      [-1, +1].each do |inc|
        neigh << [x + inc, y] if in_grid?( x + inc, y )
        neigh << [x, y + inc] if in_grid?( x, y + inc )
      end

      neigh
    end

    # Bring together the visited test below and whether the position is part of the
    # top-left block

    def candidate?( x, y )
      !visited?( x, y ) && @blocks[y][x] == @tlc
    end

    # Is the position inside the grid dimensions

    def in_grid?( x, y )
      x.between?( 0, COLUMNS - 1 ) && y.between?( 0, ROWS - 1 )
    end

    # Is the position already in the list?, actually not necessarily visited,
    # but set for visitation nevertheless

    def visited?( x, y )
      @tl_list.include?( [x, y] )
    end
  end
end
