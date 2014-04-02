require './constants'
require './block'

module ColorPuz
  # Button class
  class Button
    include Constants

    attr_reader :value

    def initialize( origin, colour, value )
      @origin = origin
      @colour = colour
      @value  = value
    end

    def draw( window )
      Block.draw_absolute( window, @origin, @colour )
    end

    def contains?( point )
      point.x.between?( @origin.x, @origin.x + BLOCK_SIZE ) &&
      point.y.between?( @origin.y, @origin.y + BLOCK_SIZE )
    end

    def to_s
      "#{@origin} #{@colour} #{@value}"
    end
  end
end
