class StartScreen
  def initialize
    @starting = false
  end

  def run(args, game)
    if @starting && !args.audio[:start_game] # wait for sfx to finish playing before changing state
      args.state.hp = 100
      args.state.secs = 0
      game.current_state = Level.new
    end

    args.audio[:bg] ||= {
      input: 'sounds/bg.mp3',  # Filename
      # x: 0.0, y: 0.0, z: 0.0,   # Relative position to the listener, x, y, z from -1.0 to 1.0
      gain: 0.4,                # Volume (0.0 to 1.0)
      pitch: 1.0,               # Pitch of the sound (1.0 = original pitch)
      paused: false,            # Set to true to pause the sound at the current playback position
      looping: true,           # Set to true to loop the sound/music until you stop it
    }

    if args.inputs.keyboard.key_down.enter
      # Change state to game level
      args.audio[:start_game] = { input: 'sounds/vgmenuselect.wav' }
      @starting = true      
    end
    args.outputs.sprites << { x: 0, y: 0, w: WIDTH, h: HEIGHT, path: 'sprites/start_screen.png'}
  end
end