require './constants'
require './block'

module FloodPuzzle
  # Button class
  class Button
    include Constants

    attr_reader :value

    def initialize(window, origin, colour, value)
      @window = window
      @origin = origin
      @colour = colour
      @value  = value
    end

    def draw
      Block.draw_absolute(@window, @origin, @colour)
    end

    def contains?(point)
      point.x.between?(left, left + BLOCK_SIZE) &&
        point.y.between?(top, top + BLOCK_SIZE)
    end

    def to_s
      "#{@origin} #{@colour} #{@value}"
    end

    def left
      @origin.x
    end

    def top
      @origin.y
    end
  end

  # Textual Button that sizes itself based on its text content
  class TextButton < Button
    def initialize(window, origin, colour, value, text)
      super(window, origin, colour, value)

      @text = text

      measure_size
    end

    def draw
      draw_background
      draw_text
    end

    private

    # Measure the button text and make the overall button size twice the height
    # and about four letters more than the width.

    def measure_size
      @text_size = @window.fonts[:button].measure(@text)
      ave_width  = @text_size.width / @text.size

      @size = Size.new(@text_size.width + 4 * ave_width, @text_size.height * 2)
    end

    def draw_background
      # Black outline
      @window.draw_rectangle(@origin, @size, 1, Gosu::Color::BLACK)

      # White interior

      @window.draw_rectangle(
        @origin.offset(1, 1), @size.deflate(2, 2), 1, Gosu::Color::WHITE
      )
    end

    def draw_text
      # Passed colour used for text

      @window.fonts[:button].draw(
        @text, @origin.x + 2 * @text_size.width / @text.size,
        @origin.y + @size.height / 4, 1, 1, 1, @colour
      )
    end
  end
end
