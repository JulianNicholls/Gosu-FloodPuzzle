require './constants'

module ColorPuz
  # Block Map, indexed Column then Row
  class BlockMap
    include Constants
    
    COLORS = [0, CYAN, ORANGE, BLUE, PURPLE, YELLOW, GREEN]

    def initialize
      @blocks = Array.new( ROWS ) { Array.new( COLUMNS ) { rand( 1..6 ) } }
    end

    def at( gpoint )
      fail 'Invalid Row'    unless gpoint.row.between?( 0, ROWS - 1 )
      fail 'Invalid Column' unless gpoint.column.between?( 0, COLUMNS - 1 )

      @blocks[gpoint.row][gpoint.column]
    end

    def game_over?
      # Every block the same colour?

      false
    end

    # Draw the occupied blocks, with no outer line.

    def draw( window )
      @blocks.each_with_index do |columns, ridx|
        columns.each_with_index do |colour, cidx|
          gpoint = GridPoint.new( ridx, cidx )
          Block.draw( window, gpoint, COLORS[colour] )
        end
      end
    end
  end
end
