require './constants'

module ColorPuz
  # Block Map, indexed Column then Row
  class BlockMap
    include Constants

    def initialize
      @blocks = Array.new( ROWS ) { Array.new( COLUMNS ) { rand( 6 ) } }
    end

    def colour( x, y )
      @blocks[x][y]
    end

    # Change the colour of the blocks rooted at the top-left corner.

    def change_colour( colour )
      return false if colour( 0, 0 ) == colour  # Cock-up, colours not changed

      build_block_list

      @change_list.each { |x, y| @blocks[x][y] = colour }

      true    # Changed colours
    end

    # Every block the same colour?

    def game_over?
      top_left = colour( 0, 0 )

      ROWS.times do |y|
        COLUMNS.times { |x| return false if colour( x, y ) != top_left }
      end

      true
    end

    # Draw the blocks

    def draw( window )
      @blocks.each_with_index do |columns, ridx|
        columns.each_with_index do |colour, cidx|
          gpoint = GridPoint.new( ridx, cidx )
          Block.draw( window, gpoint, COLOR_TABLE[colour] )
        end
      end
    end

    private

    # Build the list of positions in the block that is contiguous with the
    # top-left corner and the same colour as it is

    def build_block_list
      @change_list = [[0, 0]]

      index = 0

      while index < @change_list.size
        x, y = @change_list[index]
        @change_list << [x + 1, y] if candidate?( x + 1, y )
        @change_list << [x - 1, y] if candidate?( x - 1, y )
        @change_list << [x, y + 1] if candidate?( x, y + 1 )
        @change_list << [x, y - 1] if candidate?( x, y - 1 )

        index += 1
      end
    end

    # Bring together the two tests below and whether the position is part of the
    # top-left block

    def candidate?( x, y )
      in_grid?( x, y ) && !visited?( x, y ) && colour( x, y ) == colour( 0, 0 )
    end

    # Is the position inside the grid dimensions

    def in_grid?( x, y )
      x.between?( 0, COLUMNS - 1 ) && y.between?( 0, ROWS - 1 )
    end

    # Is the position already in the list?, actually not necessarily visited,
    # but set for visitation nevertheless

    def visited?( x, y )
      @change_list.include?( [x, y] )
    end
  end
end
