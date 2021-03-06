require 'constants'
require 'resources'

module FloodPuzzle
  # Drawing capabilities
  class Drawer
    include Constants

    def initialize(game)
      @bg_image = ResourceLoader.images(game)[:background]
      @font     = ResourceLoader.fonts(game)[:moves]
    end

    def background
      @bg_image.draw(0, 0, 0)
    end

    def moves(moves, optimal)
      text        = 'Moves  '
      size        = @font.text_width(text)
      move_colour = moves <= optimal ? GREEN : RED
      left        = GAME_BORDER * 4
      top         = GAME_BORDER + 7

      font.draw_text( text, left, top, 4, 1, 1, MOVES_COLOUR )
      font.draw_text( "#{moves} / #{optimal}", left + size, top, 4, 1, 1, move_colour )
    end

    def time(elapsed)
      text = format('Time  %d:%02d', elapsed / 60, elapsed % 60)
      size = @font.measure(text)
      left = WIDTH - (GAME_BORDER * 4) - size.width

      font.draw_text( text, left, GAME_BORDER + 7, 4, 1, 1, MOVES_COLOUR )
    end
  end
end
