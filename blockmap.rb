require './constants'

module ColorPuz
  # Block Map
  class BlockMap
    include Constants

    def initialize( easy = false )
      if easy   # Some clustering
        setup_easy
      else      # Completely random
        @blocks = Array.new( ROWS ) do
          Array.new( COLUMNS ) { rand( COLOR_TABLE.size ) }
        end
      end

      @original_blocks = @blocks
    end

    # Reset to the original created layout

    def reset
      @blocks = @original_blocks
    end

    # Revert to the blocks before the last colour change sweep.

    def revert
      @blocks = @last_blocks
    end

    # Set up a slightly easier playing field. One in seven of the blocks will be
    # the same colour as its neighbour above or to the left

    def setup_easy
      @blocks = Array.new( ROWS ) { Array.new( COLUMNS ) }

      ROWS.times do |y|
        COLUMNS.times do |x|
          if y > 0 && x > 0
            colour = rand( -1..(COLOR_TABLE.size - 1) )
            @blocks[y][x] = colour

            set_neighbour_colour( x, y ) if colour == -1
          else
            @blocks[y][x] = rand( COLOR_TABLE.size )
          end
        end
      end
    end

    def set_neighbour_colour( x, y )
      xd = rand( 2 )
      yd = 1 - xd
      @blocks[y][x] = colour( x - xd, y - yd )
    end

    def colour( x, y )
      @blocks[y][x]
    end

    # Change the colour of the blocks rooted at the top-left corner.

    def change_colour( colour )
      return false if colour( 0, 0 ) == colour  # Cock-up, colours not changed

      @last_blocks = @blocks

      build_block_list

      @change_list.each { |x, y| @blocks[y][x] = colour }

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
      ROWS.times do |y|
        COLUMNS.times do |x|
          gpoint = GridPoint.new( x, y )
          Block.draw( window, gpoint, COLOR_TABLE[colour( x, y )] )
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
