# Colo(u)r Puzzle

require './gosu_enhanced'
require './constants'
require './resources'
require './blockmap'
require './block'
require './gameover'
require './button'

module ColorPuz
  # Tetris Game
  class Game < Gosu::Window
    include Constants

    KEY_FUNCS = {
      Gosu::KbEscape =>  -> { close },
      Gosu::KbR      =>  -> { reset },

      Gosu::MsLeft   =>  -> { @position = Point.new( mouse_x, mouse_y ) }
    }

    def initialize( debug )
      super( WIDTH, HEIGHT, false, 200 )

      self.caption = 'Gosu ColorPuz'

      @fonts  = ResourceLoader.fonts( self )
#      @images = ResourceLoader.images( self )
      @sounds = ResourceLoader.sounds( self )
      @debug  = debug

      setup_buttons

      reset
    end

    def needs_cursor?   # Enable the mouse cursor
      true
    end

    def reset
      @grid       = BlockMap.new
      @paused     = false
      @game_over  = false
      @position   = nil
      @moves      = 0
    end

    def update
      update_game_over

      update_flip if @position
    end

    def update_game_over
      if !@game_over && @grid.game_over?
        @sounds[:tada].play
        @game_over = true
      end
    end

    def update_flip
      @buttons.each do |b|
        if b.contains?( @position ) && @grid.change_colour( b.value )
          @moves += 1
          @sounds[:flip].play
          break
        end
      end

      @position = nil
    end

    def draw
      draw_background
      @grid.draw( self )
      draw_buttons
      draw_moves

      draw_overlays
    end

    def draw_background
      draw_rectangle( Point.new( 0, 0 ), Size.new( WIDTH, HEIGHT ),
                      0, Gosu::Color::WHITE )

#      @images[:background].draw( 0, 0, 0 )
    end

    def draw_buttons
      @buttons.each { |b| b.draw( self ) }
    end

    def draw_moves
      text = @moves.to_s
      size = @fonts[:moves].measure( text )

      top  = GAME_BORDER + 5 * BLOCK_SIZE - size.height / 2
      left = GAME_BORDER + 5 * BLOCK_SIZE - size.width / 2
      @fonts[:moves].draw( text, left, top, 4, 1, 1, MOVES_COLOUR )
    end

    def draw_overlays
      GameOverWindow.new( self ).draw && return if @game_over
    end

    def button_down( btn_id )
      instance_exec( &KEY_FUNCS[btn_id] )
    end

    private

    def setup_buttons
      @buttons = []

      point = Point.new( GAME_BORDER + 2 * MARGIN,
                         HEIGHT - GAME_BORDER - MARGIN - BLOCK_SIZE )

      COLOR_TABLE.each_with_index do |c, idx|
        @buttons << Button.new( point, c, idx )
        point = point.offset( BLOCK_SIZE + MARGIN, 0 )
      end
    end
  end
end

debug = ARGV.first == '--debug'
puts 'Debug Mode' if debug

window = ColorPuz::Game.new( debug )
window.show
