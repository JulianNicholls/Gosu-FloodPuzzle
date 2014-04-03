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

    attr_reader :fonts

    KEY_FUNCS = {
      Gosu::KbEscape =>  -> { close },
      Gosu::KbR      =>  -> { reset },

      Gosu::MsLeft   =>  -> { @position = Point.new( mouse_x, mouse_y ) }
    }

    def initialize( debug, easy )
      super( WIDTH, HEIGHT, false, 200 )

      self.caption = 'Gosu ColorPuz'

      @fonts  = ResourceLoader.fonts( self )
#      @images = ResourceLoader.images( self )
      @sounds = ResourceLoader.sounds( self )
      @debug  = debug
      @easy   = easy

      setup_buttons

      reset
    end

    def needs_cursor?   # Enable the mouse cursor
      true
    end

    def reset
      @grid       = BlockMap.new( @easy )
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
        @sounds[:tada][rand( @sounds[:tada].size )].play
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
      @buttons.each { |b| b.draw }
    end

    def draw_moves
      text = @moves.to_s
      size = @fonts[:moves].measure( text )

      top  = GAME_BORDER + ROWS/2 * BLOCK_SIZE - size.height / 2
      left = GAME_BORDER + COLUMNS/2 * BLOCK_SIZE - size.width / 2
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

      if @debug
        point = Point.new( GAME_BORDER + MARGIN,
                           HEIGHT - GAME_BORDER - MARGIN - BLOCK_SIZE )
      else
        point = Point.new( GAME_BORDER + 2 * MARGIN,
                           HEIGHT - GAME_BORDER - MARGIN - BLOCK_SIZE )
      end

      COLOR_TABLE.each_with_index do |c, idx|
        @buttons << Button.new( self, point, c, idx )
        point = point.offset( BLOCK_SIZE + MARGIN, 0 )
      end

      @buttons << TextButton.new( self, point, RED, 99, 'Auto' ) if @debug
    end
  end
end

debug = ARGV.include? '--debug'
easy  = ARGV.include? '--easy'

puts 'Debug Mode' if debug
puts 'Easy Mode' if easy

window = ColorPuz::Game.new( debug, easy )
window.show
