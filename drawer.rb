require './constants'

module FloodPuzzle
  # Drawing capabilities
  class Drawer
    include Constants

    def initialize( surface )
      @window = surface
      @fonts  = @window.fonts
    end

    def moves( moves, optimal )
      font        = @fonts[:moves]
      text        = 'Moves  '
      size        = font.text_width( text )
      move_colour = moves <= optimal ? GREEN : RED
      left, top   = GAME_BORDER * 4, GAME_BORDER + 7

      font.draw( text, left, top, 4, 1, 1, MOVES_COLOUR )
      font.draw( "#{moves} / #{optimal}", left + size, top, 4, 1, 1, move_colour )
    end

    def time( elapsed )
      font = @fonts[:moves]
      text = format( 'Time  %d:%02d', elapsed / 60, elapsed % 60 )
      size = font.measure( text )
      left = WIDTH - (GAME_BORDER * 4) - size.width

      font.draw( text, left, GAME_BORDER + 7, 4, 1, 1, MOVES_COLOUR )
    end
  end
end
