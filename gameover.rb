require 'constants'
require 'overlaywindow.rb'

module FloodPuzzle
  # Show the window when the game is over
  class GameOverWindow < OverlayWindow
    include Constants

    P_ORIGIN  = GRID_ORIGIN.offset(BLOCK_SIZE, BLOCK_SIZE)
    P_SIZE    = Size.new((COLUMNS - 2) * BLOCK_SIZE, (ROWS - 2) * BLOCK_SIZE)

    def draw
      draw_background

      draw_header
      draw_score
      draw_instructions
    end

    private

    def draw_background
      @window.draw_rectangle(P_ORIGIN, P_SIZE, 10, Gosu::Color::WHITE)
    end

    def draw_header
      say('GAME OVER', :header,
          :center, P_ORIGIN.y + P_SIZE.height / 6, BLUE)
    end

    def draw_score
      say("SCORE: #{score_with_commas}", :info,
          :center, P_ORIGIN.y + P_SIZE.height * 2 / 5, RED)
    end

    def draw_instructions
      top     = P_ORIGIN.y
      height  = P_SIZE.height

      say('Press R to Restart', :info, :center, top + height * 3 / 5, BLUE)
      say('Press Escape to Exit', :info, :center, top + height * 4 / 5, BLUE)
    end

    def score_with_commas
      # Work through, finding...
      # Three digit sections, preceded and followed by at least one digit and...
      # Replace with the digits followed by a comma

      @window.score.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
    end
  end
end
