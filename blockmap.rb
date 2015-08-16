require 'constants'

module FloodPuzzle
  # co-ordinate pair
  Coord = Struct.new(:column, :row)

  # Co-ordinate pair with its colour
  Edge  = Struct.new(:colour, :column, :row)

  # Block Map
  class BlockMap
    include Constants

    attr_reader :optimal

    def initialize(easier)
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
      @blocks = Array.new(ROWS) do
        Array.new(COLUMNS) { rand(COLOR_TABLE.size) }
      end
    end

    # Set up a slightly easier playing field. One in seven of the blocks will be
    # the same colour as its neighbour above or to the left

    def setup_easier
      (1...ROWS).each do |row|
        (1...COLUMNS).each do |col|
          set_neighbour_colour(col, row) if rand(-1...COLOR_TABLE.size) == -1
        end
      end
    end

    # Randomly choose either the block above or left to copy the colour from.

    def set_neighbour_colour(col, row)
      xd = rand(2)
      @blocks[row][col] = @blocks[row - (1 - xd)][col - xd]
    end

    # Change the colour of the blocks rooted at the top-left corner.

    def change_colour(colour)
      # Return false if the top-left colour is already the colour requested

      return false if @tlc == colour

      build_block_list

      # Debugging 'Auto' button

      colour = best_colour if colour >= COLOR_TABLE.size

      @tl_list.each { |col, row| @blocks[row][col] = colour }
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

    def draw(window)
      ROWS.times do |row|
        COLUMNS.times do |col|
          Block.draw(window, GridPoint.new(col, row),
                     COLOR_TABLE[@blocks[row][col]])
        end
      end
    end

    private

    # Copy blocks so that they can be returned to later on, for example
    # after calculating the optimal number of flips

    def copy_blocks
      @blocks.map(&:dup)
    end

    # Calculate the minimal number of flips necessary to finish the current
    # grid. Actually, it's not quite optimal, since I've beaten it several
    # times!

    def calculate_minimal_flips
      @optimal = 0

      until game_over?
        change_colour(best_colour)
        @optimal += 1
      end

      reset
    end

    # Try to calculate what the best colour to change to would be, based on
    # the number of blocks collected by changing to that colour.

    def best_colour
      build_block_list

      edges = []

      @tl_list.each do |col, row|
        neighbours(col, row).each do |c, r|
          col = @blocks[r][c]
          edges << [col, c, r] if col != @tlc && !edges.include?([col, c, r])
        end
      end

      max_colour_count(edges)
    end

    def max_colour_count(edge_blocks)
      counts = Array.new(COLOR_TABLE.size, 0)

      edge_blocks.each { |col, _, _| counts[col] += 1 }
      counts.index(counts.max)
    end

    # Build the list of positions in the block that is contiguous with the
    # top-left corner and the same colour as it is

    def build_block_list
      @tl_list = [[0, 0]]

      @tl_list.each do |col, row|
        neighbours(col, row).each do |c, r|
          @tl_list << [c, r] if candidate?(c, r)
        end
      end
    end

    # Return a list of the in-grid neighbours of the passed position

    def neighbours(col, row)
      neigh = []

      [-1, +1].each do |inc|
        new_col = col + inc
        new_row = row + inc

        neigh << [new_col, row] if in_grid?(new_col, row)
        neigh << [col, new_row] if in_grid?(col, new_row)
      end

      neigh
    end

    # Bring together the visited test below and whether the position is part
    # of the top-left block

    def candidate?(col, row)
      !visited?(col, row) && @blocks[row][col] == @tlc
    end

    # Is the position inside the grid dimensions

    def in_grid?(col, row)
      col.between?(0, COLUMNS - 1) && row.between?(0, ROWS - 1)
    end

    # Is the position already in the list?, actually not necessarily visited,
    # but set for visitation nevertheless

    def visited?(col, row)
      @tl_list.include?([col, row])
    end
  end
end
