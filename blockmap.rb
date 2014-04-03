require 'pp'

require './constants'

module ColorPuz
  # Block Map
  class BlockMap
    include Constants

    def initialize( easy = false )
      if easy   # Some clustering
        setup_easy
      else      # Completely random
        @blocks = Array.new( ROWS ) { Array.new( COLUMNS ) { rand( COLOR_TABLE.size ) } }
      end

      @original_blocks = copy_blocks

      calculate_minimal_flips
    end

    # Reset to the original created layout

    def reset
      @blocks = @original_blocks
    end

    def copy_blocks
      copy = Array.new( ROWS ) { Array.new( COLUMNS ) }
      ROWS.times do |r|
        COLUMNS.times { |c| copy[r][c] = @blocks[r][c] }
      end
      
      copy
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

      if colour > COLOR_TABLE.size
        colour = best_colour 
      else
        build_block_list
      end

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

    def calculate_minimal_flips
      @optimal = 0

      while !game_over?
        change_colour( best_colour )
        @optimal += 1
      end

      puts "Optimal: #{@optimal}"
      reset
    end

    # Try to calculate what the best colour to change to would be, based on
    # the number of blocks collected by changing to that colour.

    def best_colour
      build_block_list
      top_left  = colour( 0, 0 )   # Find what the top-left block is coloured now
      counts    = Array.new( COLOR_TABLE.size, 0 )
      edges     = []
      index     = 0

      while index < @change_list.size
        x, y = @change_list[index]
        neighbours( x, y ).each do |c, r|
          col = colour( c, r )
          edges << [col, c, r] if col != top_left && !edges.include?( [col, c, r] )
        end

        index += 1
      end

      edges.each { |col, _, _| counts[col] += 1 }

      counts.index( counts.max )
    end

    # Build the list of positions in the block that is contiguous with the
    # top-left corner and the same colour as it is

    def build_block_list
      @change_list = [[0, 0]]

      index = 0

      while index < @change_list.size
        x, y = @change_list[index]
        neighbours( x, y ).each do |c, r|
          @change_list << [c, r] if candidate?( c, r )
        end
        index += 1
      end
    end

    def neighbours( x, y )
      neigh = []
      neigh << [x - 1, y] if in_grid?( x - 1, y )
      neigh << [x + 1, y] if in_grid?( x + 1, y )
      neigh << [x, y - 1] if in_grid?( x, y - 1 )
      neigh << [x, y + 1] if in_grid?( x, y + 1 )

      neigh
    end

    # Bring together the visited test below and whether the position is part of the
    # top-left block

    def candidate?( x, y )
      !visited?( x, y ) && colour( x, y ) == colour( 0, 0 )
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
