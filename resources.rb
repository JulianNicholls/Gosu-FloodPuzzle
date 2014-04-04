# Resource Loader

module ColorPuz
  # Resource Loader for Tetris
  class ResourceLoader
    def self.fonts( window )
      {
        button: Gosu::Font.new( window, 'Arial', 14 ),
        score:  Gosu::Font.new( window, 'Arial', 30 ),
        pause:  Gosu::Font.new( window, 'Arial', 56 ),
        moves:  Gosu::Font.new( window, 'Arial', 22 )
      }
    end
    
    def self.images( window )
      {
        background: Gosu::Image.new( window, 'media/background.png', true )
      }
    end

    def self.sounds( window )
      {
        flip: Gosu::Sample.new( window, 'media/Blip.wav' ),
        tada: [Gosu::Sample.new( window, 'media/tada.wav' ),
               Gosu::Sample.new( window, 'media/alleluia.wav' ),
               Gosu::Sample.new( window, 'media/shazam2.wav' ),
               Gosu::Sample.new( window, 'media/ww_kewl.wav' ),
               Gosu::Sample.new( window, 'media/yeehaw.wav' )]
      }
    end
  end
end
