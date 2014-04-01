require './constants'

module ColorPuz
  # Block Map, indexed Column then Row
  class BlockMap
    include Constants

    def initialize
      @blocks = Array.new( ROWS ) { Array.new( COLUMNS ) { rand( 6 ) } }
    end

    def at( gpoint )
      fail 'Invalid Row'    unless gpoint.row.between?( 0, ROWS - 1 )
      fail 'Invalid Column' unless gpoint.column.between?( 0, COLUMNS - 1 )

      @blocks[gpoint.row][gpoint.column]
    end

    def change_colour( colour )
      return if @blocks[0, 0] == colour  # Cock-up

      changes = build_block_list

      changes.each { |r, c| @blocks[r][c] = colour }
    end

    def game_over?
      # Every block the same colour?

      false
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
  end

  private

  def build_block_list
    top_left = @blocks[0][0]
    list = [[0, 0]]

    index = 0

    while index < list.size
      x, y = list[index]
      list << [x + 1, y] if x + 1 < COLUMNS && !list.include?( [x + 1, y] ) && @blocks[x + 1][y] == top_left
      list << [x - 1, y] if x > 0 && !list.include?( [x - 1, y] ) && @blocks[x - 1][y] == top_left
      list << [x, y + 1] if y + 1 < ROWS && !list.include?( [x, y + 1] ) && @blocks[x][y + 1] == top_left
      list << [x, y - 1] if y > 0 && !list.include?( [x, y - 1] ) && @blocks[x][y - 1] == top_left

      index += 1
    end

    list
  end
end
