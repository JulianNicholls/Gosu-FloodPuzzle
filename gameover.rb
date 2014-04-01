require './constants'
require './gosu_enhanced'
require './overlaywindow.rb'

module ColorPuz
  # Show the window when the game is over
  class GameOverWindow < OverlayWindow
    include Constants

    P_ORIGIN  = Point.new( 60, 110 )
    P_SIZE    = Size.new( WIDTH - (P_ORIGIN.x * 2), HEIGHT - (P_ORIGIN.y * 2) )

    def draw
      @window.draw_rectangle( P_ORIGIN, P_SIZE, 10, 0xc0ffffff )

      say( 'GAME OVER', @fonts[:pause],
           :center, P_ORIGIN.y + P_SIZE.height / 4, BLUE )

      say( 'Press R to Restart', @fonts[:score],
           :center, P_ORIGIN.y + P_SIZE.height * 3 / 5, BLUE )

      say( 'Press Escape to Exit', @fonts[:score],
           :center, P_ORIGIN.y + P_SIZE.height * 4 / 5, BLUE )
    end
  end
end
