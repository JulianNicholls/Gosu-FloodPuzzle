require './constants'

module ColorPuz
  # Hold a (row, column) position inside the ColorPuz grid
  class GridPoint < Struct.new( :row, :column )
    include Constants

    def offset( by_row, by_column )
      GridPoint.new( row + by_row, column + by_column )
    end

    def to_point
      Point.new( GAME_BORDER + column * BLOCK_SIZE, GAME_BORDER + row * BLOCK_SIZE )
    end

    def move_by!( by_row, by_column )
      self.row    += by_row
      self.column += by_column
    end
  end

  # Draw a constituent block of a Tetris shape.
  class Block
    include Constants

    # Draw in the well, using a GridPoint

    def self.draw( window, gridpoint, colour )
      draw_absolute( window, gridpoint.to_point, colour )
    end

    # Draw at an absolute pixel position

    def self.draw_absolute( window, point, colour )
      window.draw_rectangle( point, Size.new( BLOCK_SIZE, BLOCK_SIZE ), 1, colour )
    end
  end
end
