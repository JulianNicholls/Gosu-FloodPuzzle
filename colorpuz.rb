# Colo(u)r Puzzle

require './gosu_enhanced'
require './constants'
require './resources'
require './blockmap'
require './block'
require './pausewindow'
require './gameover'

module ColorPuz
  # Tetris Game
  class Game < Gosu::Window
    include Constants

    KEY_FUNCS = {
      Gosu::KbEscape =>  -> { close },
      Gosu::KbR      =>  -> { reset },

      Gosu::MsLeft   =>  -> { @position = Point.new( mouse_x, mouse_y ) }

#      Gosu::KbP      =>  -> { @paused = !@paused },
#
#      Gosu::KbDown   =>  -> { @down_pressed = true },
#      Gosu::KbLeft   =>  -> { @cur.left },
#      Gosu::KbRight  =>  -> { @cur.right },
#      Gosu::KbUp     =>  -> { @cur.rotate }
    }

    def initialize( debug )
      super( WIDTH, HEIGHT, false, 200 )

      self.caption = 'Gosu ColorPuz'

#      @fonts  = ResourceLoader.fonts( self )
#      @images = ResourceLoader.images( self )
#      @sounds = ResourceLoader.sounds( self )
#      @debug  = debug

      reset
    end

    def needs_cursor?   # Enable the mouse cursor
      true
    end

    def reset
      @stack      = BlockMap.new
      @paused     = false
      @game_over  = false
      @position   = nil
    end

    def update
#      @game_over = @stack.game_over?
    end

    def draw
      draw_background
      @stack.draw( self )

      draw_overlays
    end

    def draw_background
      draw_rectangle( Point.new( 0, 0 ), Size.new( WIDTH, HEIGHT ), 0, Gosu::Color::WHITE )
#      @images[:background].draw( 0, 0, 0 )

      point = Point.new( GAME_BORDER + MARGIN, HEIGHT - GAME_BORDER - MARGIN - BLOCK_SIZE )

      COLOR_TABLE.each do |c|
        Block.draw_absolute( self, point, c )
        point.move_by!( BLOCK_SIZE + MARGIN, 0 )
      end
    end

    def draw_overlays
      GameOverWindow.new( self ).draw && return if @game_over

      PauseWindow.new( self ).draw if @paused
    end

    def button_down( btn_id )
      instance_exec( &KEY_FUNCS[btn_id] )
    end
  end
end

debug = ARGV.first == '--debug'
puts 'Debug Mode' if debug

window = ColorPuz::Game.new( debug )
window.show
