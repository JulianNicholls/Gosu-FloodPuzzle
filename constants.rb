module ColorPuz
  # Constants for the Tetris Game
  module Constants
    GAME_BORDER   = 5
    COLUMNS       = 10
    ROWS          = 10
    BLOCK_SIZE    = 50
    
    MARGIN        = 10
    
    WIDTH         = GAME_BORDER * 2 + COLUMNS * BLOCK_SIZE
    HEIGHT        = GAME_BORDER * 2 + ROWS * BLOCK_SIZE + 2 * MARGIN + BLOCK_SIZE
                  
    CYAN          = Gosu::Color.new( 0xff, 0x00, 0xff, 0xff )
    BLUE          = Gosu::Color.new( 0xff, 0x00, 0x00, 0xff )
    ORANGE        = Gosu::Color.new( 0xff, 0xff, 0xa5, 0x00 )
    YELLOW        = Gosu::Color.new( 0xff, 0xff, 0xff, 0x00 )
    GREEN         = Gosu::Color.new( 0xff, 0x80, 0xff, 0x00 )
    PURPLE        = Gosu::Color.new( 0xff, 0x80, 0x00, 0x80 )
    RED           = Gosu::Color.new( 0xff, 0xff, 0x00, 0x00 )
  end
end
