require 'constants'

module FloodPuzzle
  # Hold a (x, y) position inside the FloodPuzzle grid
  GridPoint = Struct.new( :column, :row ) do
    def offset( by_column, by_row )
      GridPoint.new( column + by_column, row + by_row )
    end

    def to_point
      Constants::GRID_ORIGIN.offset(
        column * Constants::BLOCK_SIZE, row * Constants::BLOCK_SIZE )
    end

    def move_by!( by_column, by_row )
      self.column += by_column
      self.row    += by_row
    end
  end

  # Draw a block of colour.
  class Block
    include Constants

    # Draw in the grid, using a GridPoint

    def self.draw( window, gridpoint, colour )
      draw_absolute( window, gridpoint.to_point, colour )
    end

    # Draw at an absolute pixel position

    def self.draw_absolute( window, point, colour )
      window.draw_rectangle( point, Size.new( BLOCK_SIZE, BLOCK_SIZE ), 1, colour )
    end
  end
end
