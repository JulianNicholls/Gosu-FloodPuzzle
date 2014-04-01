require './constants'
require './gosu_enhanced'
require './overlaywindow.rb'

module ColorPuz
  # Show the window when the game is paused
  class PauseWindow < OverlayWindow
    include Constants

    P_ORIGIN  = Point.new( 60, 110 )
    P_SIZE    = Size.new( WIDTH - (P_ORIGIN.x * 2), HEIGHT - (P_ORIGIN.y * 2) )

    def draw
      @window.draw_rectangle( P_ORIGIN, P_SIZE, 10, 0xc0ffffff )

      say( 'PAUSED', @fonts[:pause], :center, P_ORIGIN.y + P_SIZE.height / 4, BLUE )
      say( 'Press P to Continue', @fonts[:score],
           :center, P_ORIGIN.y + P_SIZE.height * 3 / 5, BLUE )
    end
  end
end
