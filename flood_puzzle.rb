# Colo(u)r Puzzle

require './gosu_enhanced'
require './constants'
require './resources'
require './blockmap'
require './block'
require './gameover'
require './button'

module FloodPuzzle
  # Tetris Game
  class Game < Gosu::Window
    include Constants

    attr_reader :fonts, :score

    KEY_FUNCS = {
      Gosu::KbEscape =>  -> { close if @debug || @game_over },
      Gosu::KbR      =>  -> { reset if @game_over },

      Gosu::MsLeft   =>  -> { @position = Point.new( mouse_x, mouse_y ) }
    }

    def initialize( debug, easy )
      super( WIDTH, HEIGHT, false, 200 )

      self.caption = caption( debug, easy )

      @fonts  = ResourceLoader.fonts( self )
      @images = ResourceLoader.images( self )
      @sounds = ResourceLoader.sounds( self )

      @debug  = debug
      @easy   = easy

      setup_buttons

      reset
    end

    def caption( debug, easy )
      caption = 'Gosu Flood Puzzle'
      caption += ' (Easy)' if easy
      caption += ' (Debug)' if debug

      caption
    end

    def needs_cursor?   # Enable the mouse cursor
      true
    end

    def reset
      @grid       = BlockMap.new( @easy )
      @game_over  = false
      @position   = nil
      @moves      = 0
      @start      = Time.now
      @elapsed    = 0
      @score      = 0
    end

    def update
      update_game_over

      update_flip if @position
    end

    def update_game_over
      if !@game_over && @grid.game_over?
        @sounds[:tada][rand( @sounds[:tada].size )].play
        @score = calculate_score
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
      draw_time

      draw_overlays
    end

    def draw_background
      @images[:background].draw( 0, 0, 0 )
    end

    def draw_buttons
      @buttons.each { |b| b.draw }
    end

    def draw_moves
      @fonts[:moves].draw( "Moves: #{@moves}", GAME_BORDER * 4, GAME_BORDER + 7, 4,
                           1, 1, MOVES_COLOUR )
    end

    def draw_time
      @elapsed = (Time.now - @start).round unless @game_over

      text = format( 'Time: %3ds', @elapsed )
      size = @fonts[:moves].measure( text )

      left = WIDTH - (GAME_BORDER * 4) - size.width
      @fonts[:moves].draw( text, left, GAME_BORDER + 7, 4, 1, 1, MOVES_COLOUR )
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

      left  = @debug ? GAME_BORDER + MARGIN : GAME_BORDER + 2 * MARGIN
      point = Point.new( left, HEIGHT - GAME_BORDER - MARGIN - BLOCK_SIZE )

      COLOR_TABLE.each_with_index do |c, idx|
        @buttons << Button.new( self, point, c, idx )
        point = point.offset( BLOCK_SIZE + MARGIN, 0 )
      end

      @buttons << TextButton.new( self, point, RED, 99, 'Auto' ) if @debug
    end

    def calculate_score
      # 10,000,000 * optimal_moves * (3s per move) / (flips * seconds)

      10_000_000 * @grid.optimal * @grid.optimal * 3 / (@moves * @elapsed)
    end
  end
end

debug = ARGV.include? '--debug'
easy  = ARGV.include? '--easy'

window = FloodPuzzle::Game.new( debug, easy )
window.show
