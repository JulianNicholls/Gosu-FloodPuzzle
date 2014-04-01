# Resource Loader

module ColorPuz
  # Resource Loader for Tetris
  class ResourceLoader
    def self.fonts( window )
      {
        score:    Gosu::Font.new( window, 'Arial', 30 ),
        pause:    Gosu::Font.new( window, 'Arial', 56 )
      }
    end

    def self.images( window )
      {
        background:   Gosu::Image.new( window, 'media/background.png', true )
      }
    end

    def self.sounds( window )
      {
        drop:   Gosu::Sample.new( window, 'media/Blip.wav' ),
        smash:  Gosu::Sample.new( window, 'media/Explosion.wav' )
      }
    end
  end
end
