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
#      Gosu::KbR      =>  -> { reset },
#      Gosu::KbP      =>  -> { @paused = !@paused },
#
#      Gosu::KbDown   =>  -> { @down_pressed = true },
#      Gosu::KbLeft   =>  -> { @cur.left },
#      Gosu::KbRight  =>  -> { @cur.right },
#      Gosu::KbUp     =>  -> { @cur.rotate }
    }

    def initialize( debug )
      super( WIDTH, HEIGHT, false, 100 )

      self.caption = 'Gosu ColorPuz'

#      @fonts  = ResourceLoader.fonts( self )
#      @images = ResourceLoader.images( self )
#      @sounds = ResourceLoader.sounds( self )
#      @debug  = debug

      reset
    end

    def reset
      @stack        = BlockMap.new
      @paused       = false
      @game_over    = false
    end

    def update
#      @game_over = @stack.game_over?
    end

    def draw
#      draw_background
      @stack.draw( self )

      draw_overlays
    end

    def draw_background
      @images[:background].draw( 0, 0, 0 )
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
