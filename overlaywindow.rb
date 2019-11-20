require 'gosu_enhanced'

require 'constants'
require 'resources'

module FloodPuzzle
  # Show an overlay window
  class OverlayWindow
    include Constants

    def initialize(surface)
      @fonts  = ResourceLoader.fonts(surface)
      @window = surface
    end

    def say(text, font, left, top, colour)
      font = @fonts[font]
      size = font.measure(text)

      left = (WIDTH - size.width) / 2   if left == :center
      top  = (HEIGHT - size.height) / 2 if top  == :center

<<<<<<< HEAD
      font.draw_text( text, x, y, 10, 1, 1, colour )
=======
      font.draw(text, left, top, 10, 1, 1, colour)
>>>>>>> 82b2076ef091141ed039cd89c5da86e3a415a27a
    end
  end
end
